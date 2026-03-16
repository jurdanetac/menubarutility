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
    
    // number parsed plus it's twenty percent
    var basePlusTwentyPercent: Double?
    
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
                    let doubleParsed = Double(parsedInteger)
                    
                    // If it is an integer, calculate the 20
                    basePlusTwentyPercent = doubleParsed + (doubleParsed * 0.2)
                    
                    let data = ["basePlusTwentyPercent": basePlusTwentyPercent]
                    
                    // Post a custom notification that a change occurred
                    NotificationCenter.default.post(name: NSNotification.Name("PasteboardChangedNotification"), object: nil, userInfo: data as [AnyHashable : Any])
                }
            }
        }
    }
}
