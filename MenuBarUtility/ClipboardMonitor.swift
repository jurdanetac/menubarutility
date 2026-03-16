//
//  ClipboardMonitor.swift
//  MenuBarUtility
//
//  Created by Top Of The Line VA on 3/12/26.
//

import AppKit

class ClipboardMonitor: NSObject {
    let pasteboard = NSPasteboard.general
    var lastChangeCount: Int = 0
    var timer: Timer?
    
    func startMonitoring() {
        // Check for changes every 0.5 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkForChange), userInfo: nil, repeats: true)
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func checkForChange() {
        let currentChangeCount = pasteboard.changeCount
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            
            if let newClipboardContent = pasteboard.string(forType: .string) {
                // MLS shows thousands comma separated like 2,100
                let stringWithoutCommas = newClipboardContent.replacingOccurrences(of: ",", with: "")
                
                // Check if this new value is an integer
                if let parsedInteger = Int(stringWithoutCommas) {
                    // If it is an integer, calculate the 20%
                    let base = Double(parsedInteger)
                    let basePlusTwentyPercent = base + (base * 0.2)
                    
                    let stringBase = String(base)
                    let stringBasePlusTwentyPercent = String(basePlusTwentyPercent)
                    
                    let data = [
                        "base": stringBase,
                        "basePlusTwentyPercent": stringBasePlusTwentyPercent
                    ]
                    
                    // Post a custom notification that a change occurred
                    NotificationCenter.default.post(name: NSNotification.Name("PasteboardChangedNotification"), object: nil, userInfo: data)
                }
            }
        }
    }
}
