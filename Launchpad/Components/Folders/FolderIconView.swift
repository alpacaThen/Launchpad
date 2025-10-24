import AppKit
import SwiftUI

struct FolderIconView: View {
   let folder: Folder
   let layout: LayoutMetrics
   let isDragged: Bool
   let isEditMode: Bool
   let isHovered: Bool
   let transparency: Double
   @Environment(\.colorScheme) private var colorScheme
   
   @State private var jiggleOffset: CGFloat = 0
   @State private var jiggleRotation: Double = 0
   
   var body: some View {
      let gridSpacing: CGFloat = 1.5
      
      VStack(spacing: 8) {
         ZStack {
            RoundedRectangle(cornerRadius: layout.iconSize * LaunchPadConstants.folderCornerRadiusMultiplier)
               .fill(colorScheme == .dark ? Color.black.opacity(0.3 * transparency) : Color.white.opacity(0.3 * transparency))
               .background(RoundedRectangle(cornerRadius: layout.iconSize * 0.2).fill(.ultraThinMaterial))
               .frame(width: layout.iconSize * LaunchPadConstants.folderSizeMultiplier, height: layout.iconSize * LaunchPadConstants.folderSizeMultiplier)
            
            LazyVGrid(columns: GridLayoutUtility.createFlexibleGridColumns(count: 3, spacing: gridSpacing),spacing: gridSpacing) {
               ForEach(folder.previewApps) { app in
                  Image(nsImage: app.icon)
                     .interpolation(.high)
                     .antialiased(true)
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: layout.iconSize * 0.2, height: layout.iconSize * 0.2)
               }
               
               ForEach(folder.previewApps.count..<9, id: \.self) { _ in
                  RoundedRectangle(cornerRadius: 4)
                     .fill(Color.clear)
                     .frame(width: layout.iconSize * 0.2, height: layout.iconSize * 0.2)
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
            .multilineTextAlignment(.center)
            .frame(width: layout.cellWidth)
      }
      .scaleEffect(scaleEffect)
      .opacity(isDragged ? 0.5 : 1.0)
      .rotationEffect(.degrees(isEditMode ? jiggleRotation : 0))
      .offset(x: isEditMode ? jiggleOffset : 0, y: isEditMode ? jiggleOffset : 0)
      .animation(isDragged ? .easeInOut(duration: 0.2) : LaunchPadConstants.smoothSpringAnimation, value: isDragged)
      .animation(LaunchPadConstants.smoothSpringAnimation, value: isHovered)
      .onChange(of: isEditMode) { newValue in
         if newValue {
            startJiggling()
         } else {
            stopJiggling()
         }
      }
      .onAppear {
         if isEditMode {
            startJiggling()
         }
      }
   }
   
   private var scaleEffect: CGFloat {
      if isDragged {
         return 0.8
      } else if isHovered {
         return LaunchPadConstants.hoverScaleIncrease
      }
      return 1.0
   }
   
   private func startJiggling() {
      withAnimation(LaunchPadConstants.jiggleAnimation) {
         jiggleRotation = LaunchPadConstants.jiggleRotation * 0.8  // Slightly less rotation for folders
         jiggleOffset = LaunchPadConstants.jiggleOffset
      }
      
      // Reverse the animation after a short delay to create oscillation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         if isEditMode {
            withAnimation(LaunchPadConstants.jiggleAnimation) {
               jiggleRotation = -LaunchPadConstants.jiggleRotation * 0.8
               jiggleOffset = -LaunchPadConstants.jiggleOffset
            }
            
            // Continue the loop
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               if isEditMode {
                  startJiggling()
               }
            }
         }
      }
   }
   
   private func stopJiggling() {
      withAnimation(LaunchPadConstants.quickFadeAnimation) {
         jiggleRotation = 0
         jiggleOffset = 0
      }
   }
}
