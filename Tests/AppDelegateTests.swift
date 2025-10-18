import XCTest
@testable import Launchpad

@MainActor
final class AppDelegateTests: XCTestCase {
    
    var appDelegate: AppDelegate!
    
    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
    }
    
    override func tearDown() {
        appDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Dock Icon Re-click Tests
    
    func testApplicationShouldHandleReopenWhenAppIsVisible() {
        // Given: App is visible (not hidden)
        // When: Dock icon is clicked
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        
        // Then: Should return false to hide the app
        XCTAssertFalse(result, "Should return false when app is visible to hide it")
    }
    
    func testApplicationShouldHandleReopenWhenAppIsHidden() {
        // Given: App was hidden
        appDelegate.applicationDidHide(Notification(name: NSApplication.didHideNotification))
        
        // When: Dock icon is clicked
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        
        // Then: Should return true to show the app
        XCTAssertTrue(result, "Should return true when app was hidden to show it")
    }
    
    func testApplicationShouldHandleReopenResetsHiddenState() {
        // Given: App was hidden
        appDelegate.applicationDidHide(Notification(name: NSApplication.didHideNotification))
        
        // When: Dock icon is clicked once
        _ = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        
        // Then: Next click should hide again (state was reset)
        let secondResult = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        XCTAssertFalse(secondResult, "Should return false on second click after unhiding")
    }
}
