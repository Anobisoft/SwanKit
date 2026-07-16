//
//  AppDelegate.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//


import Cocoa
import SwanKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentRect = NSRect(x: 0, y: 0, width: 800, height: 600)
        window = NSWindow(contentRect: contentRect,
                         styleMask: [.titled, .closable, .resizable, .miniaturizable],
                         backing: .buffered,
                         defer: false)
        window.center()
        window.title = "SwanKit Demo"
        window.contentViewController = ViewController()
        window.makeKeyAndOrderFront(nil)

        NSApplication.openSecurityPrivacySettings(.camera)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
