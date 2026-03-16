//
//  MenuBarUtilityApp.swift
//  MenuBarUtility
//
//  Created by Top Of The Line VA on 3/12/26.
//

import SwiftUI
import AppKit

@main
struct MenuBarUtilityApp: App {
    // We use an AppDelegate to handle the system menu bar
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // You can leave this empty or hide it if you want a menu-bar-only app
        Settings {
            // Text("Settings View")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var observer: NSObjectProtocol?
    
    // IMPORTANT: Reference must be stored here, otherwise the timer dies immediately
    var clipboardMonitor: ClipboardMonitor?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // variableLength allows the menu bar to expand/shrink based on the text size
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "Ready"
        }
        
        setupMenu()
        setupListener()
        setupClipboardMonitor()
    }
    
    private func setupClipboardMonitor() {
        self.clipboardMonitor = ClipboardMonitor()
        self.clipboardMonitor?.startMonitoring()
    }
    
    func setupListener() {
        observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("PasteboardChangedNotification"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            // Safely check for the data
            if let data = notification.userInfo,
               let base = data["base"] as? String,
               let basePlusTwentyPercent = data["basePlusTwentyPercent"] as? String {
                // Update the button title in the menu bar
                self?.statusItem?.button?.title = "\(base) -> \(basePlusTwentyPercent)"
            }
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Copy Result", action: #selector(copyResultToClipboard), keyEquivalent: "c"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func copyResultToClipboard() {
        // Logic to copy the current 20% value back to clipboard if desired
    }
}
