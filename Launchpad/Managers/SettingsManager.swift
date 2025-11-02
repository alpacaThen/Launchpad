import Foundation

@MainActor
final class SettingsManager: ObservableObject {
   static let shared = SettingsManager()

   @Published var settings: LaunchpadSettings = LaunchpadSettings()

   private let userDefaults = UserDefaults.standard
   private let settingsKey = "LaunchpadSettings"

   private init() {
      loadSettings()
   }

   func saveSettings(newSettings: LaunchpadSettings) {
      settings = newSettings

      guard let data = try? JSONEncoder().encode(settings) else { return }
      print("Save settings.")
      userDefaults.set(data, forKey: settingsKey)
   }

   private func loadSettings() {
      print("Load settings.")
      guard let data = UserDefaults.standard.data(forKey: settingsKey) else {
         print("No saved settings found.")
         return
      }

      do {
         settings = try JSONDecoder().decode(LaunchpadSettings.self, from: data)
         print("Loaded settings.")
      } catch {
         print("Failed to load settings: \(error)")
      }
   }

   func resetToDefaults() {
      settings = LaunchpadSettings()
   }
}
