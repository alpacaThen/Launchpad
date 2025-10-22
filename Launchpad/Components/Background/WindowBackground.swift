import AppKit
import SwiftUI

struct WindowBackground: NSViewRepresentable {
   let material: NSVisualEffectView.Material
   let blendingMode: NSVisualEffectView.BlendingMode
   
   func makeNSView(context: Context) -> NSVisualEffectView {
      let view = NSVisualEffectView()
      view.material = material
      view.blendingMode = blendingMode
      view.state = .active
      return view
   }
   
   func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
