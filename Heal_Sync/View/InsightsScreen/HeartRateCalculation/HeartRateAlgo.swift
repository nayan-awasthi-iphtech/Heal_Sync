//
//  HeartRateAlgo.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import Foundation

extension HeartRateManager {
    
    // Structures to hold peak tracking state stored inside HeartRateManager
    private struct PulseState {
        static var lastRedValue: Float = 0.0
        static var lastPeakTime = Date()
        static var isRising: Bool = false
        static var validIntervals: [Double] = []
    }

    /// Called from Part 2 whenever `averageRed > 180` (finger detected)
    func processPulse(redValue: Float) {
        let now = Date()
        let timeSinceLastPeak = now.timeIntervalSince(PulseState.lastPeakTime)

        // 1. Detect Peak Transition: Red value was rising, and now begins to fall
        if PulseState.isRising && redValue < PulseState.lastRedValue {
            
            // Valid human heart rate filter
            if timeSinceLastPeak >= 0.33 && timeSinceLastPeak <= 1.5 {
                
                // Store valid peak-to-peak time interval
                PulseState.validIntervals.append(timeSinceLastPeak)
                
                // Keep only the last 8 beats for a responsive, rolling average
                if PulseState.validIntervals.count > 8 {
                    PulseState.validIntervals.removeFirst()
                }
                
                // 2. Calculate Average BPM from rolling intervals
                let averageInterval = PulseState.validIntervals.reduce(0, +) / Double(PulseState.validIntervals.count)
                let calculatedBPM = Int(60.0 / averageInterval)
                
                // Safety range check (40 - 200 BPM)
                if calculatedBPM >= 40 && calculatedBPM <= 200 {
                    DispatchQueue.main.async { [weak self] in
                        self?.currentBPM = calculatedBPM
                    }
                }
            }
            
            // Reset peak timer
            PulseState.lastPeakTime = now
            PulseState.isRising = false
            
        } else if redValue > PulseState.lastRedValue {
            PulseState.isRising = true
        }

        PulseState.lastRedValue = redValue
    }
    
    /// Resets algorithm memory when measurement stops or finger is removed
    func resetAlgorithm() {
        PulseState.lastRedValue = 0.0
        PulseState.lastPeakTime = Date()
        PulseState.isRising = false
        PulseState.validIntervals.removeAll()
    }
}
