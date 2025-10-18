import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
   private var isCurrentlyHidden = true

   func applicationDidHide(_ notification: Notification) {
      isCurrentlyHidden = true
   }

   func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
      if isCurrentlyHidden {
         isCurrentlyHidden = false
         return true
      } else {
         AppLauncher.exit()
         return false
      }
   }
}

