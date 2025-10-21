import SwiftUI
import AppKit

struct BackgroundView: View {
   let settings: LaunchpadSettings
   
   var body: some View {
      Group {
         switch settings.backgroundType {
         case .default:
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
         case .wallpaper:
            WallpaperBackgroundView()
         case .custom:
            CustomImageBackgroundView(imagePath: settings.customBackgroundPath)
         }
      }
   }
}

struct WallpaperBackgroundView: View {
   @State private var wallpaperImage: NSImage?
   
   var body: some View {
      Group {
         if let image = wallpaperImage {
            Image(nsImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .ignoresSafeArea()
         } else {
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
         }
      }
      .onAppear {
         loadWallpaper()
      }
   }
   
   private func loadWallpaper() {
      // Get the current screen's desktop image URL
      if let screen = NSScreen.main,
         let imageURL = NSWorkspace.shared.desktopImageURL(for: screen) {
         wallpaperImage = NSImage(contentsOf: imageURL)
      }
   }
}

struct CustomImageBackgroundView: View {
   let imagePath: String
   @State private var customImage: NSImage?
   
   var body: some View {
      Group {
         if let image = customImage {
            Image(nsImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .ignoresSafeArea()
         } else {
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
         }
      }
      .onAppear {
         loadCustomImage()
      }
      .onChange(of: imagePath) {
         loadCustomImage()
      }
   }
   
   private func loadCustomImage() {
      guard !imagePath.isEmpty else {
         customImage = nil
         return
      }
      
      if FileManager.default.fileExists(atPath: imagePath) {
         customImage = NSImage(contentsOfFile: imagePath)
      } else {
         customImage = nil
      }
   }
}
