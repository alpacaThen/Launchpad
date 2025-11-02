import SwiftUI

struct GridItemView: View {
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
      .rotationEffect(.degrees(isEditMode ? jiggleRotation - (LaunchPadConstants.jiggleRotation / 2) : 0))
      .animation(isDragged ? LaunchPadConstants.easeInOutAnimation : LaunchPadConstants.springAnimation, value: isDragged)
      .animation(LaunchPadConstants.springAnimation, value: scale)
      .animation(LaunchPadConstants.jiggleAnimation, value: jiggleRotation)
      .onChange(of: isEditMode) { jiggleRotation = $1 ? LaunchPadConstants.jiggleRotation : 0 }
   }

   private var scale: CGFloat {
      if isDragged {
         return LaunchPadConstants.draggedItemScale
      } else if isDraggedOn {
         return LaunchPadConstants.folderCreationScale
      } else if isHovered {
         return LaunchPadConstants.hoveredItemScale
      }
      return 1.0
   }
}
