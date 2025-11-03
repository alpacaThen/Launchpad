import AppKit
import SwiftUI

struct FolderIconView: View {
   let folder: Folder
   let layout: LayoutMetrics
   let scale: CGFloat
   let transparency: Double
   let labelColor: Color
   
   @Environment(\.colorScheme) private var colorScheme
   
   init(folder: Folder, layout: LayoutMetrics, scale: CGFloat, transparency: Double, labelColor: Color = Color(nsColor: .labelColor)) {
      self.folder = folder
      self.layout = layout
      self.scale = scale
      self.transparency = transparency
      self.labelColor = labelColor
   }

   var body: some View {
      VStack(spacing: 8) {
         ZStack {
            RoundedRectangle(cornerRadius: layout.iconSize * LaunchpadConstants.folderPreviewIconSize)
               .fill(colorScheme == .dark ? Color.black.opacity(LaunchpadConstants.overlayOpacity * transparency) : Color.white.opacity(LaunchpadConstants.overlayOpacity * transparency))
               .background(RoundedRectangle(cornerRadius: layout.iconSize * LaunchpadConstants.folderPreviewIconSize).fill(.ultraThinMaterial))
               .frame(width: layout.iconSize * LaunchpadConstants.folderSizeMultiplier, height: layout.iconSize * LaunchpadConstants.folderSizeMultiplier)

            LazyVGrid(columns: GridLayoutUtility.createFlexibleGridColumns(count: 3, spacing: LaunchpadConstants.folderPreviewSpace),spacing: LaunchpadConstants.folderPreviewSpace) {
               ForEach(folder.previewApps) { app in
                  Image(nsImage: app.icon)
                     .interpolation(.high)
                     .antialiased(true)
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: layout.iconSize * LaunchpadConstants.folderPreviewIconSize, height: layout.iconSize * LaunchpadConstants.folderPreviewIconSize)
               }

               ForEach(folder.previewApps.count..<9, id: \.self) { _ in
                  RoundedRectangle(cornerRadius: 4)
                     .fill(Color.clear)
                     .frame(width: layout.iconSize * LaunchpadConstants.folderPreviewIconSize, height: layout.iconSize * LaunchpadConstants.folderPreviewIconSize)
               }
            }
            .frame(width: layout.iconSize * 0.6, height: layout.iconSize * 0.6)
         }
         .frame(width: layout.iconSize, height: layout.iconSize)
         .clipShape(RoundedRectangle(cornerRadius: 16))
         .shadow(
            color: colorScheme == .dark ? Color.black.opacity(0.6 * transparency) : Color.black.opacity(0.3 * transparency),
            radius: 6, x: 0, y: 6
         )
         .shadow(
            color: colorScheme == .dark ? Color.black.opacity(0.3 * transparency) : Color.black.opacity(0.1 * transparency),
            radius: 4, x: 0, y: 2
         )
         Text(folder.name)
            .font(.system(size: layout.fontSize))
            .foregroundColor(labelColor)
            .lineLimit(1)
            .frame(width: layout.cellWidth)
      }
      .scaleEffect(scale)
   }
}
