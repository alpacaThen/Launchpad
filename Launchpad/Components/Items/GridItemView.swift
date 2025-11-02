import SwiftUI

struct GridItemView: View {
   let item: AppGridItem
   let layout: LayoutMetrics
   let isDragged: Bool
   let isEditMode: Bool
   let isHovered: Bool
   let settings: LaunchpadSettings
   
   var body: some View {
      Group {
         switch item {
         case .app(let app):
            AppIconView(app: app, layout: layout, isDragged: isDragged, isEditMode: isEditMode, isHovered: isHovered)
         case .folder(let folder):
            FolderIconView(folder: folder, layout: layout, isDragged: isDragged, isEditMode: isEditMode, isHovered: isHovered, transparency: settings.transparency)
         case .category:
            EmptyView()  // Categories are not displayed as grid items
         }
      }
   }
}
