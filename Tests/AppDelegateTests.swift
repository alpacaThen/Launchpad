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
    
    func testApplicationShouldHandleReopenWithVisibleWindows() {
        // When the app has visible windows and the dock icon is clicked
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: true)
        
        // The method should return false (don't show window again)
        XCTAssertFalse(result, "Should return false when app has visible windows to hide the app")
    }
    
    func testApplicationShouldHandleReopenWithoutVisibleWindows() {
        // When the app has no visible windows and the dock icon is clicked
        let result = appDelegate.applicationShouldHandleReopen(NSApplication.shared, hasVisibleWindows: false)
        
        // The method should return true (allow default behavior to show window)
        XCTAssertTrue(result, "Should return true when app has no visible windows to show the app")
    }
}
