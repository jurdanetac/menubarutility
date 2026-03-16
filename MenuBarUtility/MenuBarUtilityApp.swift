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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Use an SF Symbol or a custom image
            // button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "App Icon")
            button.title = "hello tolva"
            button.action = #selector(toggleMenu)
        }
        
        // setupMenu()
        setupListener()
        setupClipboardMonitor()
    }
    
    private func setupClipboardMonitor() {
        // monitor
        let clipboardMonitor = ClipboardMonitor()
        clipboardMonitor.startMonitoring()
        print("Clipboard monitor setup")
    }
    
    func setupListener() {
        observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("PasteboardChangedNotification"),
            object: nil,
            queue: .main // Ensures the code runs on the main thread
        ) { notification in
            // Your logic goes here 1,000
            if let content = notification.userInfo?["basePlusTwentyPercent"]! {
                print("The new text is: \(content)")
            }
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Hello World", action: #selector(doSomething), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func doSomething() {
        print("Menu item clicked!")
    }
    
    @objc func toggleMenu() {
        // This is where you would trigger a Popover or Menu
    }
}

