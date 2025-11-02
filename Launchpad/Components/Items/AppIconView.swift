import AppKit
import SwiftUI

struct AppIconView: View {
   let app: AppInfo
   let layout: LayoutMetrics
   let isDragged: Bool
   let isEditMode: Bool
   let isHovered: Bool
   
   init(app: AppInfo, layout: LayoutMetrics, isDragged: Bool, isEditMode: Bool = false, isHovered: Bool = false) {
      self.app = app
      self.layout = layout
      self.isDragged = isDragged
      self.isEditMode = isEditMode
      self.isHovered = isHovered
   }
   
   @State private var jiggleOffset: CGFloat = 0
   @State private var jiggleRotation: Double = 0

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
            .multilineTextAlignment(.center)
            .frame(width: layout.cellWidth)
      }
      .scaleEffect(scaleEffect)
      .rotationEffect(.degrees(isEditMode ? jiggleRotation : 0))
      .offset(x: isEditMode ? jiggleOffset : 0, y: isEditMode ? jiggleOffset : 0)
      .animation(isDragged ? LaunchPadConstants.quickFadeAnimation : LaunchPadConstants.smoothSpringAnimation, value: isDragged)
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
      .contextMenu {
         CategoryContextMenu(app: app)

         Divider()

         Button(action: {
            AppManager.shared.hideApp(path: app.path)
         }) {
            Label(L10n.hideApp, systemImage: "eye.slash")
         }
      }
   }
   
   private var scaleEffect: CGFloat {
      if isDragged {
         return LaunchPadConstants.draggedItemScale
      } else if isHovered {
         return LaunchPadConstants.folderCreationScale
      }
      return 1.0
   }
   
   private func startJiggling() {
      withAnimation(LaunchPadConstants.jiggleAnimation) {
         jiggleRotation = LaunchPadConstants.jiggleRotation
         jiggleOffset = LaunchPadConstants.jiggleOffset
      }
      
      // Reverse the animation after a short delay to create oscillation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         if isEditMode {
            withAnimation(LaunchPadConstants.jiggleAnimation) {
               jiggleRotation = -LaunchPadConstants.jiggleRotation
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
