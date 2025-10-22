import SwiftUI
import AppKit

struct WallpaperBackground: View {
   let blur: Double
   @State private var image: NSImage?
   
   var body: some View {
      ZStack {
         if image != nil {
            Image(nsImage: image!)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .blur(radius: blur)
         } else {
            WindowBackground()
         }
      }
      .onAppear {
         loadWallpaper()
      }
   }
   
   private func loadWallpaper() {
      if let screen = NSScreen.main,
         let imageURL = NSWorkspace.shared.desktopImageURL(for: screen) {
         image = NSImage(contentsOf: imageURL)
      }
   }
}
