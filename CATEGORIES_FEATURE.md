# App Categories Feature

## Overview
This implementation adds a comprehensive app categories feature to Launchpad, allowing users to organize applications into multiple categories (tags) for better organization and quick access.

## Features Implemented

### 1. Category Management
- **Create Categories**: Users can create new categories with custom names via the Settings panel
- **Rename Categories**: Categories can be renamed at any time
- **Delete Categories**: Categories can be deleted (apps remain unaffected)
- **Persistent Storage**: All categories are saved to UserDefaults and persist across app launches

### 2. App-Category Association
- **Multiple Categories per App**: Apps can belong to multiple categories simultaneously (tag-based system)
- **Context Menu Integration**: Right-click any app to add/remove it from categories
- **Visual Indicators**: Context menu shows checkmarks for categories the app belongs to
- **Easy Management**: Add or remove apps from categories with a single click

### 3. Category Filtering
- **Filter Bar**: Horizontal scrollable filter bar at the top of the main view
- **Quick Filtering**: Click any category to instantly filter apps by that category
- **All Apps View**: "All Apps" button to clear filters and show everything
- **Folder Support**: Folders containing apps in the selected category are also shown

### 4. Category View
- **Detailed View**: Click a category filter to open a full-screen view of all apps in that category
- **Similar to Folders**: Uses the same beautiful UI pattern as folder views
- **Editable Name**: Click the category name to rename it inline
- **Smooth Animations**: Spring animations for opening/closing

### 5. Bulk Operations
- **Open All Apps**: Press Enter when viewing a category to launch all apps in that category
- **Quick Access**: Perfect for launching a set of related apps (e.g., all development tools)

### 6. Import/Export
- **Layout Export**: Categories are included when exporting layout to JSON
- **Backward Compatible**: Import/export supports both old format (no categories) and new format
- **Full Backup**: Export creates a complete backup of both app layout and categories

## Architecture

### Models
- **`Category`**: Identifiable, Equatable, Codable struct
  - `id`: UUID for unique identification
  - `name`: User-defined category name
  - `appPaths`: Set of app paths (prevents duplicates)

### Managers
- **`CategoryManager`**: Singleton manager following the same pattern as AppManager
  - CRUD operations for categories
  - App-category association management
  - Persistence to UserDefaults
  - Import/export support

### UI Components

#### Settings
- **`CategorySettings`**: Settings panel tab for managing categories
  - Create new categories
  - List all categories with app counts
  - Rename/delete existing categories
  - Confirmation dialogs for destructive actions

#### Main UI
- **`CategoryFilterBar`**: Horizontal scrollable bar with category buttons
- **`CategoryDetailView`**: Full-screen view showing apps in a category
- **`CategoryNameView`**: Editable name header for category view
- **`CategoryIconView`**: Visual representation of categories (future use)
- **`CategoryContextMenu`**: Context menu for app-category management

### Integration Points
- **`AppGridItem`**: Extended to support `.category` case (future use for showing categories as grid items)
- **`PagedGridView`**: Enhanced with category filtering logic
- **`SinglePageView` & `SearchResultsView`**: Context menus include category options
- **`AppManager`**: Import/export methods updated to handle categories

## Usage Guide

### For Users

#### Creating Categories
1. Open Settings (Cmd+,)
2. Navigate to "Categories" tab
3. Enter a category name
4. Click the + button

#### Adding Apps to Categories
1. Right-click any app in the grid or search results
2. Select "Manage Categories"
3. Click a category name to toggle membership
4. Categories with checkmarks contain the app

#### Filtering by Category
1. Use the category filter bar at the top of the screen
2. Click any category name to filter
3. Click "All Apps" to show everything

#### Opening All Apps in a Category
1. Filter by or open a category
2. Press Enter to launch all apps in that category

#### Managing Categories
1. Open Settings > Categories
2. Click pencil icon to rename
3. Click trash icon to delete
4. All changes are automatically saved

### For Developers

#### Adding New Category Features
The category system is designed to be extensible:

```swift
// Get all categories for an app
let categories = CategoryManager.shared.getCategoriesForApp(appPath: app.path)

// Get all apps in a category
let apps = CategoryManager.shared.getAppsForCategory(category, from: allApps)

// Create a new category
let category = CategoryManager.shared.createCategory(name: "My Category")

// Add an app to a category
CategoryManager.shared.addAppToCategory(appPath: app.path, categoryId: category.id)
```

#### Testing
Comprehensive test suite in `CategoryManagerTests.swift` covers:
- Category CRUD operations
- App-category associations
- Persistence
- Import/export
- Edge cases

Run tests using Xcode Test Navigator or:
```bash
xcodebuild test -scheme Launchpad -destination 'platform=macOS'
```

## Localization

All UI strings are localized in both English and Hungarian:
- `en.lproj/Localizable.strings`
- `hu.lproj/Localizable.strings`

Key strings:
- `categories`, `untitled_category`, `new_category`
- `add_to_category`, `remove_from_category`, `manage_categories`
- `delete_category`, `open_all_apps`, `filter_by_category`

## Technical Details

### Data Persistence
- Categories stored in UserDefaults under key `"LaunchpadCategories"`
- JSON encoded using Swift's Codable protocol
- Automatic save on all modifications
- Load on app initialization

### Import/Export Format
```json
{
  "items": [ /* existing app/folder layout */ ],
  "categories": [
    {
      "id": "UUID-STRING",
      "name": "Development",
      "appPaths": [
        "/Applications/Xcode.app",
        "/Applications/Terminal.app"
      ]
    }
  ]
}
```

### Performance Considerations
- Set-based app path storage for O(1) lookups
- Lazy loading of category apps
- Efficient filtering using Swift's native collection methods
- Minimal UI updates using SwiftUI's reactive system

## Future Enhancements (Not Implemented)

Possible future additions:
1. **Smart Categories**: Auto-categorize based on app type/developer
2. **Category Colors**: Custom colors for each category
3. **Category Icons**: Custom SF Symbols for categories
4. **Category Shortcuts**: Keyboard shortcuts to switch categories
5. **Category Search**: Search within a specific category
6. **Category Statistics**: Show usage stats per category
7. **Nested Categories**: Sub-categories for more organization
8. **Category Sharing**: Export/import individual categories

## Known Limitations

1. Categories don't appear as grid items (only in filter bar)
2. No drag-and-drop for adding apps to categories (use context menu)
3. No category-specific sorting options
4. Categories reset when filtering by search text

## Compatibility

- **Minimum macOS Version**: Same as main app (macOS 12+)
- **Backward Compatible**: Old layouts without categories still import correctly
- **Forward Compatible**: Designed to be extended with additional features

## Testing Checklist

- [x] Create/rename/delete categories
- [x] Add apps to single category
- [x] Add apps to multiple categories
- [x] Remove apps from categories
- [x] Filter by category
- [x] Open all apps in category (Enter key)
- [x] Category persistence across app restarts
- [x] Import/export with categories
- [x] Backward compatible import
- [x] Context menu integration
- [x] Settings panel integration
- [x] Localization (EN/HU)
- [x] Edge cases (empty categories, non-existent apps, etc.)

## Summary

This implementation provides a complete, production-ready app categorization system that integrates seamlessly with Launchpad's existing architecture. It follows SwiftUI best practices, maintains consistency with existing code patterns, and includes comprehensive testing.
