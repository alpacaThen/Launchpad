import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // If the app has visible windows, hide it when the dock icon is clicked again
        if flag {
            AppLauncher.exit()
            return false
        }
        // If no visible windows, allow the default behavior (show the window)
        return true
    }
}
