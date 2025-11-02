import SwiftUI

struct AppGridItemView: View {
   let item: AppGridItem
   let layout: LayoutMetrics
   let isDragged: Bool
   let isDraggedOn: Bool
   let isHovered: Bool
   let isEditMode: Bool
   let settings: LaunchpadSettings

   @State private var jiggleRotation: Double = 0

   var body: some View {
      Group {
         switch item {
         case .app(let app):
            AppIconView(app: app, layout: layout, scale: scale)
         case .folder(let folder):
            FolderIconView(folder: folder, layout: layout, scale: scale, transparency: settings.transparency)
         case .category:
            EmptyView()  // Categories are not displayed as grid items
         }
      }
      .rotationEffect(.degrees(isEditMode ? jiggleRotation - (LaunchpadConstants.jiggleRotation / 2) : 0))
      .animation(isDragged ? LaunchpadConstants.easeInOutAnimation : LaunchpadConstants.springAnimation, value: isDragged)
      .animation(LaunchpadConstants.springAnimation, value: scale)
      .animation(LaunchpadConstants.jiggleAnimation, value: jiggleRotation)
      .onChange(of: isEditMode) { jiggleRotation = $1 ? LaunchpadConstants.jiggleRotation : 0 }
   }

   private var scale: CGFloat {
      if isDragged {
         return LaunchpadConstants.draggedItemScale
      } else if isDraggedOn {
         return LaunchpadConstants.folderCreationScale
      } else if isHovered && settings.enableIconAnimation {
         return LaunchpadConstants.hoveredItemScale
      }
      return 1.0
   }
}
