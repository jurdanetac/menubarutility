import AppKit

class ClipboardMonitor: NSObject {
    var lastChangeCount = 0
    var timer: Timer?

    override init() {
        super.init()
        setupClipboardMonitoring()
    }

    func setupClipboardMonitoring() {
        let pasteboard = NSPasteboard.general
        lastChangeCount = pasteboard.changeCount // Initialize the change count

        // Set up a timer to check the pasteboard every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkForClipboardChanges()
        }
    }

    @objc private func checkForClipboardChanges() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            // The clipboard content has changed
            print("Clipboard changed!")
            self.lastChangeCount = pasteboard.changeCount
            
            // You can now access the new content
            if let newString = pasteboard.string(forType: .string) {
                print("New string is: \(newString)")
            }
            
            // Perform other actions here (e.g., update UI, process data)
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}

