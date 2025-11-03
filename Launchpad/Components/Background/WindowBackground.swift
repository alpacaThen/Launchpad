import AppKit
import SwiftUI

struct WindowBackground: NSViewRepresentable {
   func makeNSView(context: Context) -> NSVisualEffectView {
      let view = NSVisualEffectView()
      view.material = .fullScreenUI
      view.blendingMode = .behindWindow
      view.state = .active
      return view
   }
   
   func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
      nsView.material = .fullScreenUI
      nsView.blendingMode = .behindWindow
   }
}
