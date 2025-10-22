import XCTest
import AppKit
@testable import Launchpad

@MainActor
final class CategoryManagerTests: XCTestCase {
   
   var categoryManager: CategoryManager!
   var mockUserDefaults: UserDefaults!
   
   override func setUp() {
      super.setUp()
      
      // Create a separate UserDefaults instance for testing
      mockUserDefaults = UserDefaults(suiteName: "test.launchpad.categorymanager")!
      
      // Clear any existing test data
      mockUserDefaults.removePersistentDomain(forName: "test.launchpad.categorymanager")
      
      // Use shared instance but clean up test data
      categoryManager = CategoryManager.shared
      
      // Clear test data from shared UserDefaults
      UserDefaults.standard.removeObject(forKey: "LaunchpadCategories")
      categoryManager.clearAllCategories()
   }
   
   override func tearDown() {
      // Clean up test data
      UserDefaults.standard.removeObject(forKey: "LaunchpadCategories")
      mockUserDefaults.removePersistentDomain(forName: "test.launchpad.categorymanager")
      categoryManager.clearAllCategories()
      super.tearDown()
   }
   
   // MARK: - Initialization Tests
   
   func testCategoryManagerSingleton() {
      let instance1 = CategoryManager.shared
      let instance2 = CategoryManager.shared
      XCTAssertTrue(instance1 === instance2, "CategoryManager should be a singleton")
   }
   
   func testInitialState() {
      XCTAssertEqual(categoryManager.categories.count, 0, "Should initialize with no categories")
   }
   
   // MARK: - Category Creation Tests
   
   func testCreateCategory() {
      // When: Creating a new category
      let category = categoryManager.createCategory(name: "Development")
      
      // Then: Category should be created and added to the list
      XCTAssertEqual(category.name, "Development")
      XCTAssertEqual(categoryManager.categories.count, 1)
      XCTAssertTrue(categoryManager.categories.contains { $0.id == category.id })
      XCTAssertTrue(category.appPaths.isEmpty, "New category should have no apps")
   }
   
   func testCreateMultipleCategories() {
      // When: Creating multiple categories
      let category1 = categoryManager.createCategory(name: "Work")
      let category2 = categoryManager.createCategory(name: "Personal")
      let category3 = categoryManager.createCategory(name: "Games")
      
      // Then: All categories should be in the list
      XCTAssertEqual(categoryManager.categories.count, 3)
      XCTAssertTrue(categoryManager.categories.contains { $0.id == category1.id })
      XCTAssertTrue(categoryManager.categories.contains { $0.id == category2.id })
      XCTAssertTrue(categoryManager.categories.contains { $0.id == category3.id })
   }
   
   // MARK: - Category Deletion Tests
   
   func testDeleteCategory() {
      // Given: A category exists
      let category = categoryManager.createCategory(name: "ToDelete")
      XCTAssertEqual(categoryManager.categories.count, 1)
      
      // When: Deleting the category
      categoryManager.deleteCategory(category: category)
      
      // Then: Category should be removed
      XCTAssertEqual(categoryManager.categories.count, 0)
   }
   
   func testDeleteNonExistentCategory() {
      // Given: Some categories exist
      let category1 = categoryManager.createCategory(name: "Keep")
      let category2 = Category(name: "NotInList")
      
      // When: Attempting to delete a category not in the list
      categoryManager.deleteCategory(category: category2)
      
      // Then: Original categories should remain
      XCTAssertEqual(categoryManager.categories.count, 1)
      XCTAssertTrue(categoryManager.categories.contains { $0.id == category1.id })
   }
   
   // MARK: - Category Rename Tests
   
   func testRenameCategory() {
      // Given: A category exists
      let category = categoryManager.createCategory(name: "OldName")
      
      // When: Renaming the category
      categoryManager.renameCategory(category: category, newName: "NewName")
      
      // Then: Category name should be updated
      XCTAssertEqual(categoryManager.categories[0].name, "NewName")
   }
   
   func testRenameNonExistentCategory() {
      // Given: Some categories exist
      categoryManager.createCategory(name: "Existing")
      let nonExistent = Category(name: "NotInList")
      
      // When: Attempting to rename a category not in the list
      categoryManager.renameCategory(category: nonExistent, newName: "NewName")
      
      // Then: Existing categories should remain unchanged
      XCTAssertEqual(categoryManager.categories.count, 1)
      XCTAssertEqual(categoryManager.categories[0].name, "Existing")
   }
   
   // MARK: - App-Category Association Tests
   
   func testAddAppToCategory() {
      // Given: A category exists
      let category = categoryManager.createCategory(name: "Productivity")
      let appPath = "/Applications/Safari.app"
      
      // When: Adding an app to the category
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category.id)
      
      // Then: App should be in the category
      XCTAssertEqual(categoryManager.categories[0].appPaths.count, 1)
      XCTAssertTrue(categoryManager.categories[0].appPaths.contains(appPath))
   }
   
   func testAddMultipleAppsToCategory() {
      // Given: A category exists
      let category = categoryManager.createCategory(name: "Tools")
      let app1 = "/Applications/Safari.app"
      let app2 = "/Applications/Notes.app"
      let app3 = "/Applications/Calculator.app"
      
      // When: Adding multiple apps
      categoryManager.addAppToCategory(appPath: app1, categoryId: category.id)
      categoryManager.addAppToCategory(appPath: app2, categoryId: category.id)
      categoryManager.addAppToCategory(appPath: app3, categoryId: category.id)
      
      // Then: All apps should be in the category
      XCTAssertEqual(categoryManager.categories[0].appPaths.count, 3)
      XCTAssertTrue(categoryManager.categories[0].appPaths.contains(app1))
      XCTAssertTrue(categoryManager.categories[0].appPaths.contains(app2))
      XCTAssertTrue(categoryManager.categories[0].appPaths.contains(app3))
   }
   
   func testAddAppToMultipleCategories() {
      // Given: Multiple categories exist
      let category1 = categoryManager.createCategory(name: "Work")
      let category2 = categoryManager.createCategory(name: "Communication")
      let appPath = "/Applications/Mail.app"
      
      // When: Adding the same app to multiple categories
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category1.id)
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category2.id)
      
      // Then: App should be in both categories
      XCTAssertTrue(categoryManager.categories[0].appPaths.contains(appPath))
      XCTAssertTrue(categoryManager.categories[1].appPaths.contains(appPath))
   }
   
   func testRemoveAppFromCategory() {
      // Given: A category with an app
      let category = categoryManager.createCategory(name: "Media")
      let appPath = "/Applications/Music.app"
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category.id)
      
      // When: Removing the app from the category
      categoryManager.removeAppFromCategory(appPath: appPath, categoryId: category.id)
      
      // Then: App should be removed
      XCTAssertEqual(categoryManager.categories[0].appPaths.count, 0)
      XCTAssertFalse(categoryManager.categories[0].appPaths.contains(appPath))
   }
   
   // MARK: - Category Query Tests
   
   func testGetCategoriesForApp() {
      // Given: Multiple categories with overlapping apps
      let category1 = categoryManager.createCategory(name: "Work")
      let category2 = categoryManager.createCategory(name: "Favorites")
      let appPath = "/Applications/Safari.app"
      
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category1.id)
      categoryManager.addAppToCategory(appPath: appPath, categoryId: category2.id)
      
      // When: Getting categories for the app
      let categories = categoryManager.getCategoriesForApp(appPath: appPath)
      
      // Then: Should return both categories
      XCTAssertEqual(categories.count, 2)
      XCTAssertTrue(categories.contains { $0.id == category1.id })
      XCTAssertTrue(categories.contains { $0.id == category2.id })
   }
   
   func testGetCategoriesForAppWithNoCategories() {
      // Given: Categories exist but app is not in any
      categoryManager.createCategory(name: "Work")
      let appPath = "/Applications/Safari.app"
      
      // When: Getting categories for the app
      let categories = categoryManager.getCategoriesForApp(appPath: appPath)
      
      // Then: Should return empty array
      XCTAssertEqual(categories.count, 0)
   }
   
   // MARK: - Persistence Tests
   
   func testCategoryPersistence() {
      // Given: Categories are created with apps
      let category1 = categoryManager.createCategory(name: "Development")
      categoryManager.addAppToCategory(appPath: "/Applications/Xcode.app", categoryId: category1.id)
      
      // When: Creating a new instance (simulating app restart)
      let newManager = CategoryManager.shared
      
      // Then: Categories should be loaded from UserDefaults
      XCTAssertEqual(newManager.categories.count, 1)
      XCTAssertEqual(newManager.categories[0].name, "Development")
      XCTAssertTrue(newManager.categories[0].appPaths.contains("/Applications/Xcode.app"))
   }
   
   // MARK: - Import/Export Tests
   
   func testExportCategories() {
      // Given: Categories with apps
      let category1 = categoryManager.createCategory(name: "Work")
      let category2 = categoryManager.createCategory(name: "Games")
      categoryManager.addAppToCategory(appPath: "/Applications/Safari.app", categoryId: category1.id)
      categoryManager.addAppToCategory(appPath: "/Applications/Chess.app", categoryId: category2.id)
      
      // When: Exporting categories
      let result = categoryManager.exportCategories()
      
      // Then: Export should succeed
      XCTAssertTrue(result.success, "Export should succeed")
      XCTAssertTrue(result.message.contains("successfully"), "Message should indicate success")
      
      // Verify the categories are still in the manager
      XCTAssertEqual(categoryManager.categories.count, 2)
      XCTAssertTrue(categoryManager.categories.contains { $0.name == "Work" })
      XCTAssertTrue(categoryManager.categories.contains { $0.name == "Games" })
   }
   
   // MARK: - Clear Tests
   
   func testClearAllCategories() {
      // Given: Multiple categories exist
      categoryManager.createCategory(name: "Work")
      categoryManager.createCategory(name: "Personal")
      XCTAssertEqual(categoryManager.categories.count, 2)
      
      // When: Clearing all categories
      categoryManager.clearAllCategories()
      
      // Then: All categories should be removed
      XCTAssertEqual(categoryManager.categories.count, 0)
   }
}
