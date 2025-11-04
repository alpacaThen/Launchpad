import SwiftUI
import AppKit

struct BackgroundView: View {
   @EnvironmentObject private var settingsManager: SettingsManager

   var body: some View {
      Group {
         switch settingsManager.settings.backgroundType {
         case .default:
            WindowBackground()
         case .wallpaper:
            WallpaperBackground(blur: settingsManager.settings.backgroundBlur)
         case .custom:
            ImageBackground(path: settingsManager.settings.customBackgroundPath, blur: settingsManager.settings.backgroundBlur)
         }
      }
      .ignoresSafeArea()
   }
}
