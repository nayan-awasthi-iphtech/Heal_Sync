//
//  HeartRateManager.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import Foundation
import AVFoundation
import Combine

class HeartRateManager: NSObject, ObservableObject {
    @Published var currentBPM: Int = 0
    @Published var isMeasuring: Bool = false
    @Published var fingerDetected: Bool = false
    
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    
    func startMeasurement(){
        guard !captureSession.isRunning else {return }
        SetupAndStartCamera()
    }
    
    func stopMeasurement(){
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
        toggleTorch(on: false)
        
        DispatchQueue.main.async{
            self.isMeasuring = false        
            self.fingerDetected = false
        }
    }
    
    private func SetupAndStartCamera(){
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .low
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: device) else {
            captureSession.commitConfiguration()
            print("failed to access rear camera")
            return
        }
        self.videoDevice = device
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
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
            print("Could not lock camera settings: \(error)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            self?.toggleTorch(on: true)
            
            DispatchQueue.main.async {
                self?.isMeasuring = true
            }
        }
    }
    
    private func toggleTorch(on: Bool) {
        guard let device = videoDevice ?? AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch activation error: \(error)")
        }
    }
}
