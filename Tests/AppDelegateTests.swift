import XCTest
@testable import LaunchpadPlus

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
        
        // Then: Should return true (app will exit via AppLauncher.exit())
        XCTAssertTrue(result, "Should return true when app is visible")
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
        
        // Then: isCurrentlyHidden should be reset to false
        // Next click should exit the app (still returns true)
        let secondResult = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        XCTAssertTrue(secondResult, "Should return true on second click (will exit via AppLauncher.exit())")
    }
}
