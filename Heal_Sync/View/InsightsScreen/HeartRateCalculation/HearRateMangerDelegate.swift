//
//  HearRateMangerDelegate.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import AVFoundation

extension HeartRateManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }
        
        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        var totalGreen: Int = 0
        var totalBlue: Int = 0
        var totalRed: Int = 0
        let totalPixels = width * height
        
        // Pixel format BGRA: [0: Blue, 1: Green, 2: Red, 3: Alpha]
        for i in 0..<totalPixels {
            let blueComponent = buffer[i * 4]
            let greenComponent = buffer[i * 4 + 1]
            let redComponent = buffer[i * 4 + 2]
            
            totalBlue += Int(blueComponent)
            totalGreen += Int(greenComponent)
            totalRed += Int(redComponent)
        }
        
        let averageRed = Float(totalRed) / Float(totalPixels)
        let averageGreen = Float(totalGreen) / Float(totalPixels)
        let averageBlue = Float(totalBlue) / Float(totalPixels)
        
        let isFingerCovering = averageRed > 180 && averageRed > (averageGreen + averageBlue)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if averageRed > 180 {
                self.fingerDetected = true
                self.processPulse(redValue: averageRed)
                
            } else {
                self.fingerDetected = false
                self.currentBPM = 0
                self.resetAlgorithm()
            }
        }
    }
}
