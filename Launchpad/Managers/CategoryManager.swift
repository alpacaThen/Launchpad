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
   
   // MARK: - Category Management
   
   func createCategory(name: String) -> Category {
      let category = Category(name: name)
      categories.append(category)
      saveCategories()
      return category
   }
   
   func deleteCategory(_ category: Category) {
      categories.removeAll { $0.id == category.id }
      saveCategories()
   }
   
   func renameCategory(_ category: Category, newName: String) {
      guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
      categories[index].name = newName
      saveCategories()
   }
   
   // MARK: - App-Category Association
   
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
   
   func getAppsForCategory(_ category: Category, from allApps: [AppInfo]) -> [AppInfo] {
      let appsByPath = Dictionary(uniqueKeysWithValues: allApps.map { ($0.path, $0) })
      return category.appPaths.compactMap { appsByPath[$0] }
   }
   
   // MARK: - Persistence
   
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
   
   // MARK: - Import/Export
   
   func exportCategories() -> [[String: Any]] {
      return categories.map { category in
         [
            "id": category.id.uuidString,
            "name": category.name,
            "appPaths": Array(category.appPaths)
         ]
      }
   }
   
   func importCategories(from data: [[String: Any]]) {
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
   
   func clearAllCategories() {
      print("Clear all categories.")
      categories = []
      userDefaults.removeObject(forKey: categoriesKey)
      userDefaults.synchronize()
   }
}
