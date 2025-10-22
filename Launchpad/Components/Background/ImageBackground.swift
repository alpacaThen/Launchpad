import SwiftUI
import AppKit

struct ImageBackground: View {
   let path: String
   let blur: Double
   @State private var customImage: NSImage?
   
   var body: some View {
      Group {
         if let image = customImage {
            Image(nsImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .ignoresSafeArea()
               .blur(radius: blur)
         }
      }
      .onAppear {
         loadCustomImage()
      }
      .onChange(of: path) {
         loadCustomImage()
      }
   }
   
   private func loadCustomImage() {
      guard !path.isEmpty else {
         customImage = nil
         return
      }
      
      if FileManager.default.fileExists(atPath: path) {
         customImage = NSImage(contentsOfFile: path)
      } else {
         customImage = nil
      }
   }
}
