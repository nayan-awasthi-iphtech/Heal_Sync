import Foundation
import AVFoundation
import Combine

class HeartRateManager: NSObject, ObservableObject {
    @Published var currentBPM: Int = 0
    @Published var isMeasuring: Bool = false
    @Published var fingerDetected: Bool = false
    @Published var scanProgress: Double = 0
    @Published var errorMessage: String?

    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let sampleQueue = DispatchQueue(label: "com.healsync.heartrate.samplebuffer")

    var lastRedValue: Float = 0.0
    var lastPeakMediaTime: Double = 0
    var isRising: Bool = false
    var validIntervals: [Double] = []
    var redHistory: [Float] = []
    var risePeak: Float = 0.0
    var riseValley: Float = 0.0
    var lastSavedAt: Date?
    var consecutiveNoFingerFrames: Int = 0
    var didDetectFingerOnce: Bool = false
    var hasSignalStarted: Bool = false

    private let maxScanDuration: TimeInterval = 30
    private let maxNoFingerFrames = 45
    private let requiredIntervals = 8
    private var measurementTimer: Timer?

    func startMeasurement() {
        guard !captureSession.isRunning, !isMeasuring else { return }
        errorMessage = nil
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            beginScan()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.beginScan()
                    } else {
                        self?.errorMessage = InsightsScreenConstants.cameraDeniedMessage
                    }
                }
            }
        case .denied, .restricted:
            errorMessage = InsightsScreenConstants.cameraDeniedMessage
        @unknown default:
            errorMessage = InsightsScreenConstants.cameraDeniedMessage
        }
    }

    private func beginScan() {
        currentBPM = 0
        scanProgress = 0
        fingerDetected = false
        resetAlgorithm()
        didDetectFingerOnce = false
        consecutiveNoFingerFrames = 0
        SetupAndStartCamera()
        measurementTimer?.invalidate()
        measurementTimer = Timer.scheduledTimer(withTimeInterval: maxScanDuration, repeats: false) { [weak self] _ in
            self?.finishMeasurement()
        }
    }

    func finishMeasurement() {
        measurementTimer?.invalidate()
        measurementTimer = nil
        guard captureSession.isRunning else {
            DispatchQueue.main.async { [weak self] in
                self?.isMeasuring = false
                self?.scanProgress = 1
            }
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
            self?.toggleTorch(on: false)
            DispatchQueue.main.async {
                if let self = self, self.currentBPM > 0 {
                    HeartRateStore.shared.saveReading(bpm: self.currentBPM)
                }
                self?.isMeasuring = false
                self?.fingerDetected = false
                self?.scanProgress = 1
                self?.resetAlgorithm()
            }
        }
    }

    func cancelMeasurement() {
        measurementTimer?.invalidate()
        measurementTimer = nil
        guard captureSession.isRunning else {
            DispatchQueue.main.async { [weak self] in
                self?.isMeasuring = false
            }
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
            self?.toggleTorch(on: false)
            DispatchQueue.main.async {
                self?.isMeasuring = false
                self?.fingerDetected = false
                self?.currentBPM = 0
                self?.scanProgress = 0
                self?.resetAlgorithm()
            }
        }
    }

    func stopMeasurement() {
        cancelMeasurement()
    }

    func reportFingerDetected(red: Float, timestamp: Double) {
        consecutiveNoFingerFrames = 0
        didDetectFingerOnce = true
        if fingerDetected == false {
            DispatchQueue.main.async { [weak self] in
                self?.fingerDetected = true
            }
        }
        processPulse(redValue: red, timestamp: timestamp)
    }

    func reportFingerMissing() {
        if fingerDetected == true {
            DispatchQueue.main.async { [weak self] in
                self?.fingerDetected = false
            }
        }
        guard didDetectFingerOnce else { return }
        consecutiveNoFingerFrames += 1
        if consecutiveNoFingerFrames >= maxNoFingerFrames {
            consecutiveNoFingerFrames = 0
            finishMeasurement()
        }
    }

    private func SetupAndStartCamera() {
        captureSession.beginConfiguration()
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        if let oldOutput = videoOutput {
            captureSession.removeOutput(oldOutput)
            videoOutput = nil
        }
        captureSession.sessionPreset = .low
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: device) else {
            captureSession.commitConfiguration()
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = InsightsScreenConstants.cameraDeniedMessage
                self?.isMeasuring = false
                self?.measurementTimer?.invalidate()
                self?.measurementTimer = nil
            }
            return
        }
        self.videoDevice = device
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        output.alwaysDiscardsLateVideoFrames = true
        guard captureSession.canAddOutput(output) else {
            captureSession.commitConfiguration()
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = InsightsScreenConstants.cameraDeniedMessage
                self?.isMeasuring = false
                self?.measurementTimer?.invalidate()
                self?.measurementTimer = nil
            }
            return
        }
        captureSession.addOutput(output)
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        self.videoOutput = output
        do {
            try device.lockForConfiguration()
            if device.isExposureModeSupported(.locked) {
                device.exposureMode = .locked
            }
            if device.isWhiteBalanceModeSupported(.locked) {
                device.whiteBalanceMode = .locked
            }
            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
        captureSession.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            self?.toggleTorch(on: true)
            DispatchQueue.main.async {
                self?.isMeasuring = true
            }
        }
    }

    private func toggleTorch(on: Bool) {
        guard let device = videoDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            try? device.unlockForConfiguration()
        }
    }

    deinit {
        measurementTimer?.invalidate()
        if captureSession.isRunning {
            captureSession.stopRunning()
            try? videoDevice?.lockForConfiguration()
            videoDevice?.torchMode = .off
            videoDevice?.unlockForConfiguration()
        }
    }
}
