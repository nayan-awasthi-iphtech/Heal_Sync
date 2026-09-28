import Foundation

extension HeartRateManager {

    private static let smoothingWindow = 5
    private static let minPeakDelta: Float = 1.0

    func processPulse(redValue: Float, timestamp: Double) {
        redHistory.append(redValue)
        if redHistory.count > Self.smoothingWindow {
            redHistory.removeFirst()
        }
        if redHistory.count < Self.smoothingWindow {
            lastRedValue = redHistory.reduce(0, +) / Float(redHistory.count)
            risePeak = lastRedValue
            riseValley = lastRedValue
            return
        }
        let smooth = redHistory.reduce(0, +) / Float(redHistory.count)
        if lastPeakMediaTime == 0 {
            lastPeakMediaTime = timestamp
            lastRedValue = smooth
            risePeak = smooth
            riseValley = smooth
            hasSignalStarted = true
            return
        }
        let timeSinceLastPeak = timestamp - lastPeakMediaTime
        if smooth > lastRedValue {
            if !isRising {
                riseValley = lastRedValue
                isRising = true
            }
            risePeak = max(risePeak, smooth)
        } else if smooth < lastRedValue {
            if isRising {
                let amplitude = risePeak - riseValley
                if amplitude >= Self.minPeakDelta {
                    if timeSinceLastPeak >= 0.33 && timeSinceLastPeak <= 1.5 {
                        validIntervals.append(timeSinceLastPeak)
                        if validIntervals.count > 8 {
                            validIntervals.removeFirst()
                        }
                        let averageInterval = validIntervals.reduce(0, +) / Double(validIntervals.count)
                        let calculatedBPM = Int(60.0 / averageInterval)
                        if calculatedBPM >= 40 && calculatedBPM <= 200 {
                            let progress = min(1.0, Double(validIntervals.count) / 8.0)
                            let isComplete = validIntervals.count >= 8
                            let now = Date()
                            DispatchQueue.main.async { [weak self] in
                                self?.currentBPM = calculatedBPM
                                self?.scanProgress = progress
                            }
                            if self.lastSavedAt == nil || now.timeIntervalSince(self.lastSavedAt!) >= 15 {
                                HeartRateStore.shared.saveReading(bpm: calculatedBPM, at: now)
                                self.lastSavedAt = now
                            }
                            if isComplete {
                                self.finishMeasurement()
                            }
                        }
                    }
                    lastPeakMediaTime = timestamp
                }
                isRising = false
                risePeak = smooth
                riseValley = smooth
            }
        }
        lastRedValue = smooth
    }

    func resetAlgorithm() {
        lastRedValue = 0.0
        lastPeakMediaTime = 0
        isRising = false
        validIntervals.removeAll()
        redHistory.removeAll()
        risePeak = 0.0
        riseValley = 0.0
        lastSavedAt = nil
        consecutiveNoFingerFrames = 0
        hasSignalStarted = false
    }
}
