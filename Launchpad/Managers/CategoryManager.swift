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

   func importCategories() -> (success: Bool, message: String) {
      let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LaunchpadCategories.json")
      let result = importCategoriesFromJSON(filePath: filePath)
      saveCategories()
      return result
   }

   func exportCategories() -> (success: Bool, message: String) {
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

   private func importCategoriesFromJSON(filePath: URL) -> (success: Bool, message: String) {
      guard FileManager.default.fileExists(atPath: filePath.path) else {
         print("Categories file not found at \(filePath.path)")
         return (false, "Categories file not found at \n\(filePath.path)")
      }

      do {
         let jsonData = try Data(contentsOf: filePath)
         let itemsArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]

         var categories: [Category] = []
         for itemsData in itemsArray {
            let idString = itemsData["id"] as! String
            let id = UUID(uuidString: idString)!
            let name = itemsData["name"] as! String
            let paths = itemsData["appPaths"] as! [String]

            categories.append(Category(id: id, name: name, appPaths: Set(paths)))
         }
         saveCategories()
         print("Successfully imported categories from \(filePath.path)")
         return (true, "Successfully imported layout from \n\(filePath.path)")
      } catch {
         print("Failed to import categories \(error)")
         return (false, "Failed to import categories \n\(error.localizedDescription)")
      }
   }

   private func exportCategoriesToJSON(filePath: URL) -> (success: Bool, message: String) {
      do {
         let exportData = categories.map { category in [
            "id": category.id.uuidString,
            "name": category.name,
            "appPaths": Array(category.appPaths)
         ]}

         let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
         try jsonData.write(to: filePath)
         print("Categories export finished successfully to \(filePath.path)")
         return (true, "Categories export finished successfully to \n\(filePath.path)")
      } catch {
         print("Failed to export categories \(error)")
         return (false, "Failed to export categories \n\(error.localizedDescription)")
      }
   }

      private func clearAllCategories() {
         print("Clear all categories.")
         categories = []
         userDefaults.removeObject(forKey: categoriesKey)
         userDefaults.synchronize()
      }
   }
