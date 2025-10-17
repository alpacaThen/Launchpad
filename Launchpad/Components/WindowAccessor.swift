import SwiftUI

struct WindowAccessor: NSViewRepresentable {
   func makeNSView(context: Context) -> NSView {
      let view = NSView()
      DispatchQueue.main.async {
         guard let currentWindow = view.window else { return }
         
         let newWindow = ResponsiveWindow(
            contentRect: currentWindow.frame,
            styleMask: currentWindow.styleMask,
            backing: .buffered,
            defer: false
         )
         
         newWindow.contentView = currentWindow.contentView
         
         configureWindow(window: newWindow)
         
         currentWindow.close()
      }
      return view
   }
   
   private func configureWindow(window: NSWindow) {
      window.titleVisibility = .hidden
      window.styleMask.remove([.resizable, .titled])
      window.level = .floating
      window.setFrame(NSScreen.main?.frame ?? .zero, display: true)
      window.makeKeyAndOrderFront(nil)
   }
   
   func updateNSView(_ nsView: NSView, context: Context) {}
   
   final class ResponsiveWindow: NSWindow {
      override var canBecomeKey: Bool { true }
      override var canBecomeMain: Bool { true }
      override var acceptsFirstResponder: Bool { true }
   }
}
