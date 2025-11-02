import XCTest
import AppKit
@testable import LaunchpadPlus

@MainActor
final class AppManagerSortTests: BaseTestCase {
   
   // MARK: - Sort by Name Tests
   
   func testSortByName() {
      let apps = createMockApps(count: 5, startingPage: 0)
      appManager.pages = [apps]
      
      appManager.sortItems(by: .name, appsPerPage: 20)
      
      let sortedNames = appManager.pages.flatMap { $0 }.compactMap { item -> String? in
         if case .app(let app) = item {
            return app.name
         }
         return nil
      }
      
      XCTAssertEqual(sortedNames, sortedNames.sorted(), "Apps should be sorted alphabetically by name")
   }
   
   func testSortByNameWithFolders() {
      let mockIcon = NSImage(size: NSSize(width: 64, height: 64))
      let app1 = AppInfo(name: "Zebra", icon: mockIcon, path: "/App1.app", bundleId: "com.test.1", lastOpenedDate: nil, installDate: nil, page: 0)
      let app2 = AppInfo(name: "Apple", icon: mockIcon, path: "/App2.app", bundleId: "com.test.2", lastOpenedDate: nil, installDate: nil, page: 0)
      let folder = createMockFolder(name: "Folder B", page: 0, appCount: 2)
      
      appManager.pages = [[.app(app1), .app(app2), .folder(folder)]]
      
      appManager.sortItems(by: .name, appsPerPage: 20)
      
      let items = appManager.pages.flatMap { $0 }
      XCTAssertEqual(items.count, 3, "Should have 3 items")
      
      if case .app(let firstApp) = items[0] {
         XCTAssertEqual(firstApp.name, "Apple", "First item should be Apple")
      } else {
         XCTFail("First item should be an app")
      }
   }
   
   // MARK: - Sort by Type Tests
   
   func testSortByType() {
      let apps = createMockApps(count: 3, startingPage: 0)
      let folder = createMockFolder(name: "Test Folder", page: 0, appCount: 2)
      
      appManager.pages = [[.folder(folder), apps[0], apps[1], apps[2]]]
      
      appManager.sortItems(by: .itemType, appsPerPage: 20)
      
      let items = appManager.pages.flatMap { $0 }
      
      // Folders should come first
      if case .folder = items[0] {
         // Good
      } else {
         XCTFail("First item should be a folder when sorted by type")
      }
   }
   
   // MARK: - Sort by Last Opened Tests
   
   func testSortByLastOpened() {
      let mockIcon = NSImage(size: NSSize(width: 64, height: 64))
      let now = Date()
      let yesterday = Date(timeIntervalSinceNow: -86400)
      let lastWeek = Date(timeIntervalSinceNow: -604800)
      
      let app1 = AppInfo(name: "App1", icon: mockIcon, path: "/App1.app", bundleId: "com.test.1", lastOpenedDate: lastWeek, installDate: nil, page: 0)
      let app2 = AppInfo(name: "App2", icon: mockIcon, path: "/App2.app", bundleId: "com.test.2", lastOpenedDate: now, installDate: nil, page: 0)
      let app3 = AppInfo(name: "App3", icon: mockIcon, path: "/App3.app", bundleId: "com.test.3", lastOpenedDate: yesterday, installDate: nil, page: 0)
      
      appManager.pages = [[.app(app1), .app(app2), .app(app3)]]
      
      appManager.sortItems(by: .lastOpened, appsPerPage: 20)
      
      let items = appManager.pages.flatMap { $0 }
      
      // Most recently opened should be first
      if case .app(let firstApp) = items[0] {
         XCTAssertEqual(firstApp.name, "App2", "Most recently opened app should be first")
      } else {
         XCTFail("First item should be an app")
      }
   }
   
   func testSortByLastOpenedWithNilDates() {
      let mockIcon = NSImage(size: NSSize(width: 64, height: 64))
      let now = Date()
      
      let app1 = AppInfo(name: "App1", icon: mockIcon, path: "/App1.app", bundleId: "com.test.1", lastOpenedDate: nil, installDate: nil, page: 0)
      let app2 = AppInfo(name: "App2", icon: mockIcon, path: "/App2.app", bundleId: "com.test.2", lastOpenedDate: now, installDate: nil, page: 0)
      let app3 = AppInfo(name: "App3", icon: mockIcon, path: "/App3.app", bundleId: "com.test.3", lastOpenedDate: nil, installDate: nil, page: 0)
      
      appManager.pages = [[.app(app1), .app(app2), .app(app3)]]
      
      appManager.sortItems(by: .lastOpened, appsPerPage: 20)
      
      let items = appManager.pages.flatMap { $0 }
      
      // Apps with dates should come before apps without dates
      if case .app(let firstApp) = items[0] {
         XCTAssertNotNil(firstApp.lastOpenedDate, "Apps with last opened dates should come first")
      }
   }
   
   // MARK: - Sort by Install Date Tests
   
   func testSortByInstallDate() {
      let mockIcon = NSImage(size: NSSize(width: 64, height: 64))
      let now = Date()
      let yesterday = Date(timeIntervalSinceNow: -86400)
      let lastWeek = Date(timeIntervalSinceNow: -604800)
      
      let app1 = AppInfo(name: "App1", icon: mockIcon, path: "/App1.app", bundleId: "com.test.1", lastOpenedDate: nil, installDate: now, page: 0)
      let app2 = AppInfo(name: "App2", icon: mockIcon, path: "/App2.app", bundleId: "com.test.2", lastOpenedDate: nil, installDate: lastWeek, page: 0)
      let app3 = AppInfo(name: "App3", icon: mockIcon, path: "/App3.app", bundleId: "com.test.3", lastOpenedDate: nil, installDate: yesterday, page: 0)
      
      appManager.pages = [[.app(app1), .app(app2), .app(app3)]]
      
      appManager.sortItems(by: .installDate, appsPerPage: 20)
      
      let items = appManager.pages.flatMap { $0 }
      
      // Most recently installed should be first
      if case .app(let firstApp) = items[0] {
         XCTAssertEqual(firstApp.name, "App1", "Most recently installed app should be first")
      } else {
         XCTFail("First item should be an app")
      }
   }
   
   // MARK: - Sort Persistence Tests
   
   func testSortPersistsAcrossPages() {
      let apps = createMockApps(count: 50, startingPage: 0)
      appManager.pages = [apps]
      
      appManager.sortItems(by: .name, appsPerPage: 20)
      
      // Should have multiple pages
      XCTAssertGreaterThan(appManager.pages.count, 1, "Should have multiple pages")
      
      // Names should be sorted across all pages
      let allNames = appManager.pages.flatMap { $0 }.compactMap { item -> String? in
         if case .app(let app) = item {
            return app.name
         }
         return nil
      }
      
      XCTAssertEqual(allNames, allNames.sorted(), "Apps should remain sorted across multiple pages")
   }
   
   func testSortTriggersLayoutRecalculation() {
      let apps = createMockApps(count: 25, startingPage: 0)
      appManager.pages = [apps]
      
      appManager.sortItems(by: .name, appsPerPage: 10)
      
      // Should redistribute apps across pages after sorting
      XCTAssertEqual(appManager.pages.count, 3, "Should have 3 pages for 25 apps with 10 per page")
      
      // Verify page sizes
      XCTAssertEqual(appManager.pages[0].count, 10, "First page should have 10 apps")
      XCTAssertEqual(appManager.pages[1].count, 10, "Second page should have 10 apps")
      XCTAssertEqual(appManager.pages[2].count, 5, "Third page should have 5 apps")
   }
}
