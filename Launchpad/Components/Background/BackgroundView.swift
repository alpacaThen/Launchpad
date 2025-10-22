import SwiftUI
import AppKit

struct BackgroundView: View {
   let settings: LaunchpadSettings

   var body: some View {
      Group {
         switch settings.backgroundType {
         case .default:
            WindowBackground(material: .fullScreenUI, blendingMode: .behindWindow)
         case .wallpaper:
            WallpaperBackground(blur: settings.backgroundBlur)
         case .custom:
            ImageBackground(path: settings.customBackgroundPath, blur: settings.backgroundBlur)
         }
      }
   }
}
