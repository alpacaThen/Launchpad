# Manual Testing Guide - App Categories Feature

## Test Scenarios

### 1. Category Creation & Management

#### Test: Create a new category
**Steps:**
1. Open Launchpad
2. Press Cmd+, to open Settings
3. Navigate to "Categories" tab (4th tab with tag icon)
4. Type "Development" in the text field
5. Click the + button

**Expected Result:**
- Category "Development" appears in the list below
- Text field is cleared
- Category count shows (0) apps initially

#### Test: Rename a category
**Steps:**
1. In Categories settings, find an existing category
2. Click the pencil icon next to the category name
3. Change name to "Dev Tools"
4. Click "Apply" or press Enter

**Expected Result:**
- Category name updates immediately
- Name persists after closing settings

#### Test: Delete a category
**Steps:**
1. In Categories settings, click trash icon next to a category
2. Confirm deletion in the alert dialog

**Expected Result:**
- Category is removed from list
- Apps are NOT deleted (remain in grid)
- Confirmation dialog explains apps won't be deleted

---

### 2. App-Category Association

#### Test: Add app to single category
**Steps:**
1. Close Settings to return to main grid
2. Right-click on Safari.app
3. Click "Manage Categories" in context menu
4. Select "Development" from submenu

**Expected Result:**
- Submenu shows all available categories
- Category has no checkmark initially
- After clicking, Safari is added to Development category

#### Test: Add app to multiple categories
**Steps:**
1. Right-click Safari.app again
2. Select "Manage Categories" > "Work"
3. Right-click Safari.app again
4. Open "Manage Categories" submenu

**Expected Result:**
- Both "Development" and "Work" show checkmarks
- Safari belongs to both categories
- Other categories have no checkmarks

#### Test: Remove app from category
**Steps:**
1. Right-click Safari.app
2. Select "Manage Categories" > "Development" (checked)

**Expected Result:**
- Checkmark disappears
- Safari removed from Development category
- Safari still in "Work" category

---

### 3. Category Filtering

#### Test: Filter by category
**Steps:**
1. Look at the category filter bar at top of screen
2. Click "Development" category button

**Expected Result:**
- Only apps in Development category are shown
- Folders containing Development apps are shown
- Page indicators update to reflect filtered pages
- "Development" button highlighted in filter bar

#### Test: Clear category filter
**Steps:**
1. While filtered by a category, click "All Apps" button

**Expected Result:**
- All apps and folders are shown again
- "All Apps" button is now highlighted
- Normal page layout restored

#### Test: Filter with multiple apps
**Steps:**
1. Add 5+ apps to "Development" category
2. Click "Development" in filter bar
3. Verify all 5+ apps are visible
4. Note any folders containing these apps

**Expected Result:**
- All apps in category are shown
- Folders with at least one app in category are shown
- Empty pages are hidden
- Page count adjusts accordingly

---

### 4. Category Detail View

#### Test: Open category detail view
**Steps:**
1. While viewing filtered apps, or
2. Click a category button in filter bar

**Expected Result:**
- Full-screen overlay appears (similar to folder view)
- Shows glass morphism background
- Category name at top
- Grid of all apps in category
- Smooth scale/fade animation on open

#### Test: Rename category in detail view
**Steps:**
1. Open category detail view
2. Click category name at top
3. Edit the name
4. Press Enter

**Expected Result:**
- Name field becomes editable
- Keyboard appears automatically
- Name updates everywhere (filter bar, settings)
- View remains open after rename

#### Test: Close category detail view
**Steps:**
1. Open category detail view
2. Click outside the category panel (on dark overlay)

**Expected Result:**
- View closes with smooth animation
- Returns to filtered view or main grid
- Category filter remains active

---

### 5. Launch All Apps in Category

#### Test: Launch all apps with Enter key
**Steps:**
1. Add 3-4 apps to a category (e.g., Safari, Mail, Notes)
2. Filter by that category or open detail view
3. Press Enter key

**Expected Result:**
- All apps in the category launch simultaneously
- Multiple app windows open
- Launchpad remains open (doesn't exit)
- Works even if some apps are already running

---

### 6. Search with Categories

#### Test: Search while category is filtered
**Steps:**
1. Filter by "Development" category
2. Start typing a search query

**Expected Result:**
- Search overrides category filter
- Shows search results from all apps (not just category)
- Category filter bar remains visible
- Returning to empty search restores category filter

#### Test: Context menu in search results
**Steps:**
1. Search for an app
2. Right-click on search result
3. Select "Manage Categories"

**Expected Result:**
- Context menu works in search results
- Can add/remove categories from search view
- Checkmarks reflect current category membership

---

### 7. Persistence & Restart

#### Test: Category persistence
**Steps:**
1. Create 3 categories with different names
2. Add various apps to different categories
3. Close Launchpad completely (Cmd+Q or Force Quit)
4. Reopen Launchpad

**Expected Result:**
- All categories still exist
- App-category associations preserved
- Category names unchanged
- Can immediately filter by categories

---

### 8. Import/Export

#### Test: Export layout with categories
**Steps:**
1. Create categories and add apps to them
2. Open Settings > Actions
3. Click "Export Layout"
4. Check ~/Documents/LaunchpadLayout.json

**Expected Result:**
- JSON file created
- Contains "items" array (apps/folders)
- Contains "categories" array with:
  - id, name, appPaths for each category

#### Test: Import layout with categories
**Steps:**
1. Clear all apps (Settings > Actions > Clear Grid Layout)
2. In Settings > Actions, click "Import Layout"

**Expected Result:**
- Apps and folders restored
- Categories restored with same names
- App-category associations restored
- Can filter by imported categories

#### Test: Backward compatible import
**Steps:**
1. Take an old LaunchpadLayout.json (without categories)
2. Import it

**Expected Result:**
- Apps and folders import successfully
- No error messages
- Categories section handled gracefully (empty)
- Existing categories are not affected

---

### 9. Edge Cases

#### Test: Empty category
**Steps:**
1. Create a category but don't add any apps
2. Try to filter by it

**Expected Result:**
- Category appears in filter bar
- Clicking it shows no apps (empty grid)
- "No apps found" or similar message?
- Can still open category detail view

#### Test: Delete app that's in categories
**Steps:**
1. Add Safari to "Development" category
2. Hide Safari (right-click > Hide App)

**Expected Result:**
- Safari no longer appears in grid
- Safari no longer appears when filtering by Development
- Category still exists with Safari's path stored
- Unhiding Safari restores it to the category

#### Test: Maximum categories
**Steps:**
1. Create 20+ categories
2. Scroll through filter bar

**Expected Result:**
- Filter bar scrolls horizontally
- All categories accessible
- Smooth scrolling experience
- No performance degradation

#### Test: Long category names
**Steps:**
1. Create category with very long name (50+ characters)
2. View in filter bar and settings

**Expected Result:**
- Name truncated appropriately in filter bar
- Full name visible in settings
- No layout breaking
- Tooltip shows full name on hover?

---

### 10. Localization

#### Test: Hungarian localization
**Steps:**
1. Change macOS language to Hungarian
2. Restart Launchpad
3. Check all category-related UI

**Expected Result:**
- All category strings in Hungarian:
  - "Kategóriák"
  - "Új Kategória"
  - "Kategóriák Kezelése"
  - etc.
- UI layout adapts to translated text
- No English strings visible

---

## Performance Checklist

- [ ] Creating category is instant (< 100ms)
- [ ] Filtering by category is instant
- [ ] Opening category view is smooth (no lag)
- [ ] Context menu appears quickly
- [ ] Large categories (100+ apps) perform well
- [ ] Switching between categories is smooth
- [ ] Import/export completes in reasonable time

## Visual Quality Checklist

- [ ] Filter bar matches app design language
- [ ] Glass morphism styling consistent
- [ ] Animations are smooth (60 FPS)
- [ ] Colors match light/dark mode
- [ ] Text is readable in all themes
- [ ] Icons and spacing look professional
- [ ] No visual glitches during transitions

## Accessibility Checklist

- [ ] Keyboard navigation works throughout
- [ ] VoiceOver announces categories correctly
- [ ] Color contrast meets WCAG standards
- [ ] Touch targets are appropriately sized
- [ ] Focus indicators are visible

---

## Known Limitations (As Designed)

1. Categories don't appear as grid items (only in filter bar)
2. No drag-and-drop for category assignment (use context menu)
3. No category-specific sorting options yet
4. Search overrides category filter
5. Categories filtered out when searching

## Reporting Issues

If you find any bugs during testing, please report:
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/screen recording
- macOS version
- Launchpad version
- Console logs (if applicable)
