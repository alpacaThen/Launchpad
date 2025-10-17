import AppKit

final class ResponsiveWindow: NSWindow {
   override var canBecomeKey: Bool { true }
   override var canBecomeMain: Bool { true }
   override var acceptsFirstResponder: Bool { true }

}
