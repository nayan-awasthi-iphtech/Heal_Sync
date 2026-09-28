import AVFoundation

extension HeartRateManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA else { return }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        guard width > 0, height > 0,
              let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }
        guard bytesPerRow >= width * 4 else { return }
        let sampleWidth = max(1, width / 4)
        let sampleHeight = max(1, height / 4)
        let startX = (width - sampleWidth) / 2
        let startY = (height - sampleHeight) / 2
        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        var totalGreen: Int = 0
        var totalBlue: Int = 0
        var totalRed: Int = 0
        var sampledPixels = 0
        for y in stride(from: startY, to: startY + sampleHeight, by: 2) {
            for x in stride(from: startX, to: startX + sampleWidth, by: 2) {
                let offset = y * bytesPerRow + x * 4
                totalBlue += Int(buffer[offset])
                totalGreen += Int(buffer[offset + 1])
                totalRed += Int(buffer[offset + 2])  
                sampledPixels += 1
            }
        }
        guard sampledPixels > 0 else { return }
        let averageRed = Float(totalRed) / Float(sampledPixels)
        let averageGreen = Float(totalGreen) / Float(sampledPixels)
        let averageBlue = Float(totalBlue) / Float(sampledPixels)
        let isFingerCovering = averageRed > 150 && averageRed > averageGreen && averageRed > averageBlue
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds
        guard timestamp > 0 else { return }
        if isFingerCovering {
            self.reportFingerDetected(red: averageRed, timestamp: timestamp)
        } else {
            self.reportFingerMissing()
        }
    }
}
