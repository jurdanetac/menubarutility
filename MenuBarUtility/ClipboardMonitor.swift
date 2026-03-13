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
            // Post a custom notification that a change occurred
            NotificationCenter.default.post(name: NSNotification.Name("PasteboardChangedNotification"), object: nil)
            
            if let newClipboardContent = pasteboard.string(forType: .string) {
                print("Clipboard changed! New value: \(newClipboardContent)")
                
                let stringWithoutCommas = newClipboardContent.replacingOccurrences(of: ",", with: "")
                
                // Check if this new value is an integer
                if let parsedIntegerFromClipboard = Int(stringWithoutCommas) {
                    // If it is an integer, calculate the 20% 2,100
                    basePlusTwentyPercent = Double(parsedIntegerFromClipboard) + (Double(parsedIntegerFromClipboard) * 0.2)
                }
            }
        }
    }
}
