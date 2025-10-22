import SwiftUI
import AppKit

struct WallpaperBackground: View {
   let blur: Double
   @State private var wallpaperImage: NSImage?
   
   var body: some View {
      Group {
         if let image = wallpaperImage {
            Image(nsImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .ignoresSafeArea()
               .blur(radius: blur)
         }
      }
      .onAppear {
         loadWallpaper()
      }
   }
   
   private func loadWallpaper() {
      if let screen = NSScreen.main,
         let imageURL = NSWorkspace.shared.desktopImageURL(for: screen) {
         wallpaperImage = NSImage(contentsOf: imageURL)
      }
   }
}
