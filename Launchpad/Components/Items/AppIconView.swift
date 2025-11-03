import AppKit
import SwiftUI

struct AppIconView: View {
   let app: AppInfo
   let layout: LayoutMetrics
   let scale: CGFloat
   let labelColor: Color

   init(app: AppInfo, layout: LayoutMetrics, scale: CGFloat, labelColor: Color = Color(nsColor: .labelColor)) {
      self.app = app
      self.layout = layout
      self.scale = scale
      self.labelColor = labelColor
   }

   var body: some View {
      VStack(spacing: 8) {
         Image(nsImage: app.icon)
            .interpolation(.high)
            .antialiased(true)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: layout.iconSize, height: layout.iconSize)
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)

         Text(app.name)
            .font(.system(size: layout.fontSize))
            .foregroundColor(labelColor)
            .lineLimit(1)
            .frame(width: layout.cellWidth)
      }
      .scaleEffect(scale)
      .contextMenu {
         CategoryContextMenu(app: app)

         Divider()

         Button(action: { AppManager.shared.hideApp(path: app.path) }) {
            Label(L10n.hideApp, systemImage: "eye.slash")
         }
      }
   }
}
