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
            // Post a custom notification that a change occurred
            NotificationCenter.default.post(name: NSNotification.Name("PasteboardChangedNotification"), object: nil)
            print("Clipboard changed!")
            // You can also get the new content here, e.g., pasteboard.string(forType: .string)
        }
    }
}
