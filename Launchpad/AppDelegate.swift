import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
   private var isCurrentlyHidden = false
   
   func applicationDidHide(_ notification: Notification) {
      print("Hiding Launchpad.")
      isCurrentlyHidden = true
   }
   
   func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
      print("Reopening Launchpad.")
      if isCurrentlyHidden {
         isCurrentlyHidden = false
      } else {
         AppLauncher.exit()
      }

      return true
   }
}
