import Foundation

@MainActor
final class CategoryManager: ObservableObject {
   static let shared = CategoryManager()

   private let userDefaults = UserDefaults.standard
   private let categoriesKey = "LaunchpadCategories"

   @Published var categories: [Category] = []

   private init() {
      loadCategories()
   }

   func createCategory(name: String) {
      let category = Category(name: name)
      categories.append(category)
      saveCategories()
   }

   func deleteCategory(category: Category) {
      categories.removeAll { $0.id == category.id }
      saveCategories()
   }

   func renameCategory(category: Category, newName: String) {
      guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
      categories[index].name = newName
      saveCategories()
   }

   func addAppToCategory(appPath: String, categoryId: UUID) {
      guard let index = categories.firstIndex(where: { $0.id == categoryId }) else { return }
      categories[index].appPaths.insert(appPath)
      saveCategories()
   }

   func removeAppFromCategory(appPath: String, categoryId: UUID) {
      guard let index = categories.firstIndex(where: { $0.id == categoryId }) else { return }
      categories[index].appPaths.remove(appPath)
      saveCategories()
   }

   func getCategoriesForApp(appPath: String) -> [Category] {
      return categories.filter { $0.appPaths.contains(appPath) }
   }

   func getAppsForCategory(category: Category, from allApps: [AppInfo]) -> [AppInfo] {
      let appsByPath = Dictionary(uniqueKeysWithValues: allApps.map { ($0.path, $0) })
      return category.appPaths.compactMap { appsByPath[$0] }
   }

   func importCategoriesFromJSON() -> (success: Bool, message: String) {
      let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LaunchpadCategories.json")
      let result = importCategoriesFromJSON(filePath: filePath)
      saveCategories()
      return result
   }

   func exportCategories() -> (success: Bool, path: String) {
      let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LaunchpadCategories.json")
      return exportCategoriesToJSON(filePath: filePath)
   }

   private func saveCategories() {
      print("Save categories.")
      do {
         let data = try JSONEncoder().encode(categories)
         userDefaults.set(data, forKey: categoriesKey)
         userDefaults.synchronize()
      } catch {
         print("Failed to save categories: \(error)")
      }
   }

   private func loadCategories() {
      print("Load categories.")
      guard let data = userDefaults.data(forKey: categoriesKey) else {
         print("No saved categories found.")
         return
      }

      do {
         categories = try JSONDecoder().decode([Category].self, from: data)
         print("Loaded \(categories.count) categories.")
      } catch {
         print("Failed to load categories: \(error)")
         categories = []
      }
   }

   private func exportCategoriesToJSON(filePath: URL) -> Bool {
      do {
         var exportData = categories.map { category in [
            "id": category.id.uuidString,
            "name": category.name,
            "appPaths": Array(category.appPaths)
         ] }

         let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
         try jsonData.write(to: filePath)
         print("Export finished successfully to \(filePath.path)!")
         return true
      } catch {
         print("Failed to export layout: \(error)")
         return false
      }
   }
   private func importCategoriesFromJSON(filePath: URL) -> (success: Bool, message: String) {
      guard FileManager.default.fileExists(atPath: filePath.path) else {
         print("Import file not found at: \(filePath.path)")
         return (false, "Layout file not found at:\n\(filePath.path)")
      }

      do {
         let jsonData = try Data(contentsOf: filePath)
         guard let exportData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            // Backward compatibility: try loading as array of items
            let itemsArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            return (false, "Could not loat items from file:\n\(filePath.path)")
         }


         if let data = exportData["categories"] as? [[String: Any]] {
            categories = data.compactMap { dict in
               guard let idString = dict["id"] as? String,
                     let id = UUID(uuidString: idString),
                     let name = dict["name"] as? String,
                     let paths = dict["appPaths"] as? [String] else {
                  return nil
               }
               return Category(id: id, name: name, appPaths: Set(paths))
            }
            saveCategories()
         }
      } catch {
         print("Failed to import layout: \(error)")
         return (false, "Failed to import layout:\n\(error.localizedDescription)")
      }
   }

   private func clearAllCategories() {
      print("Clear all categories.")
      categories = []
      userDefaults.removeObject(forKey: categoriesKey)
      userDefaults.synchronize()
   }
}
