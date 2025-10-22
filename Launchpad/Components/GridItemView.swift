import SwiftUI

struct GridItemView: View {
   let item: AppGridItem
   let layout: LayoutMetrics
   let isDragged: Bool
   let settings: LaunchpadSettings
   
   var body: some View {
      Group {
         switch item {
         case .app(let app):
            AppIconView(app: app, layout: layout, isDragged: isDragged, settings: settings)
         case .folder(let folder):
            FolderIconView(folder: folder, layout: layout, isDragged: isDragged, transparency: settings.transparency)
         case .category:
            EmptyView()  // Categories are not displayed as grid items
         }
      }
   }
}
