import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
   private var isCurrentlyHidden = true

   func applicationDidHide(_ notification: Notification) {
      print("Hiding Launchpad.")
      isCurrentlyHidden = true
   }

   func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
      print("Reopening Launchpad.")
      if isCurrentlyHidden || !flag {
         isCurrentlyHidden = false
         return true
      } else {
         AppLauncher.exit()
         return false
      }
   }
}
