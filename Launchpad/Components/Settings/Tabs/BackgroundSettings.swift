import SwiftUI
import AppKit

struct BackgroundSettings: View {
   @Binding var settings: LaunchpadSettings
   @State private var showFileError = false

   var body: some View {
      VStack(alignment: .leading, spacing: 20) {
         VStack(alignment: .leading, spacing: 12) {
            Text(L10n.backgroundType)
               .font(.headline)

            Picker("", selection: $settings.backgroundType) {
               Text(L10n.backgroundDefault).tag(BackgroundType.default)
               Text(L10n.backgroundWallpaper).tag(BackgroundType.wallpaper)
               Text(L10n.backgroundCustom).tag(BackgroundType.custom)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            Divider()
               .padding(.vertical, 4)

            Text(L10n.backgroundBlur)
               .font(.headline)

            HStack {
               Text("0%")
                  .font(.caption)
                  .foregroundColor(.secondary)

               Slider(value: $settings.backgroundBlur, in: 0...30)

               Text("100%")
                  .font(.caption)
                  .foregroundColor(.secondary)
            }

            if settings.backgroundType == .custom {
               Divider()
                  .padding(.vertical, 4)

               Text(L10n.customImagePath)
                  .font(.headline)

               HStack(spacing: 12) {
                  TextField("", text: $settings.customBackgroundPath)
                     .textFieldStyle(.roundedBorder)
                     .disabled(true)

                  Button(L10n.browseImage) {
                     selectImageFile()
                  }
                  .buttonStyle(.bordered)
               }

               if !settings.customBackgroundPath.isEmpty {
                  if FileManager.default.fileExists(atPath: settings.customBackgroundPath) {
                     Text("✓ " + settings.customBackgroundPath)
                        .font(.caption)
                        .foregroundColor(.green)
                  } else {
                     Text("⚠ " + L10n.imageNotFound)
                        .font(.caption)
                        .foregroundColor(.red)
                  }
               }
            }
         }

         Spacer()
      }
      .padding(.horizontal, 8)
   }

   private func selectImageFile() {
      let panel = NSOpenPanel()
      panel.message = L10n.selectImageMessage
      panel.allowsMultipleSelection = false
      panel.canChooseDirectories = false
      panel.canChooseFiles = true
      panel.allowedContentTypes = [.png, .jpeg, .heic, .bmp, .tiff]

      let response = panel.runModal()
      if response == .OK, let url = panel.url {
         DispatchQueue.main.async {
            settings.customBackgroundPath = url.path
         }
      }
   }
}
