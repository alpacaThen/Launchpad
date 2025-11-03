import SwiftUI
import AppKit

struct ImageBackground: View {
   let path: String
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
         loadImage()
      }
      .onChange(of: path) {
         loadImage()
      }
   }
   
   private func loadImage() {
      guard !path.isEmpty else { return }
      
      if FileManager.default.fileExists(atPath: path) {
         image = NSImage(contentsOfFile: path)
      } else {
         image = nil
      }
   }
}
