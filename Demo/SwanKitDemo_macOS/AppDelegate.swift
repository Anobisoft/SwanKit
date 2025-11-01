
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

        Access.video.accessRequest { granted in
            if granted {
                print("granted")
            } else {
                print("denny")
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
