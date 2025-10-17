import SwiftUI

struct WindowAccessor: NSViewRepresentable {
   func makeNSView(context: Context) -> NSView {
      let view = NSView()
      DispatchQueue.main.async {
         guard let currentWindow = view.window else { return }

         // DRASTIC: Replace the window with our custom ResponsiveWindow
         let newWindow = ResponsiveWindow(
            contentRect: currentWindow.frame,
            styleMask: currentWindow.styleMask,
            backing: .buffered,
            defer: false
         )

         // Transfer all properties from old window
         newWindow.contentView = currentWindow.contentView
         newWindow.titleVisibility = .hidden
         newWindow.styleMask.remove([.resizable, .titled])
         newWindow.level = .floating
         newWindow.setFrame(NSScreen.main?.frame ?? .zero, display: true)
         newWindow.acceptsMouseMovedEvents = true
         newWindow.isMovableByWindowBackground = false
         newWindow.backgroundColor = .clear
         newWindow.isOpaque = false

         // Make it key and order front
         newWindow.makeKeyAndOrderFront(nil)

         // Close the old window
         currentWindow.close()
      }
      return view
   }

   func updateNSView(_ nsView: NSView, context: Context) {}
}
