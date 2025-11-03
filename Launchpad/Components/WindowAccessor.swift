import SwiftUI

struct WindowAccessor: NSViewRepresentable {
   func makeNSView(context: Context) -> NSView {
      let view = AccessorView()
      view.onWindowAvailable = { window in
         let newWindow = ResponsiveWindow(
            contentRect: window.frame,
            styleMask: window.styleMask,
            backing: .buffered,
            defer: false
         )

         newWindow.contentView = window.contentView
         configureWindow(window: newWindow)

         window.close()
      }
      return view
   }

   private func configureWindow(window: NSWindow) {
      window.level = .floating
      window.styleMask = [.fullSizeContentView]
      window.setFrame(window.screen?.frame ?? .zero, display: true, animate: false)
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
   }

   func updateNSView(_ nsView: NSView, context: Context) {}

   final class AccessorView: NSView {
      var onWindowAvailable: ((NSWindow) -> Void)?
      private var hasConfigured = false

      override func viewDidMoveToWindow() {
         super.viewDidMoveToWindow()
         guard let window = window, !hasConfigured else { return }
         hasConfigured = true
         onWindowAvailable?(window)
      }
   }

   final class ResponsiveWindow: NSWindow {
      override var canBecomeKey: Bool { true }
      override var canBecomeMain: Bool { true }
      override var acceptsFirstResponder: Bool { true }
   }
}
