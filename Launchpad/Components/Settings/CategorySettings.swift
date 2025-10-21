import SwiftUI

struct CategorySettings: View {
   private let categoryManager = CategoryManager.shared
   @ObservedObject private var appManager = AppManager.shared

   @State private var newCategoryName = ""
   @State private var showDeleteAlert = false
   @State private var categoryToDelete: Category?

   var body: some View {

      VStack(alignment: .leading, spacing: 20) {
         Text(L10n.categories)
            .font(.headline)

         Text(L10n.categoriesDescription)
            .font(.subheadline)
            .foregroundColor(.secondary)

         Divider()

         // Create new category
         VStack(alignment: .leading, spacing: 12) {
            Text(L10n.createCategory)
               .font(.subheadline)
               .fontWeight(.medium)

            HStack {
               TextField(L10n.categoryName, text: $newCategoryName)
                  .textFieldStyle(RoundedBorderTextFieldStyle())

               Button(action: createCategory) {
                  Image(systemName: "plus.circle.fill")
                     .font(.title2)
               }
               .buttonStyle(.borderless)
               .disabled(newCategoryName.isEmpty)
            }
            .padding(.horizontal, 4)
         }

         Divider()

         // Create demo categories button
         VStack(alignment: .leading, spacing: 12) {
            Text("Quick Setup")
               .font(.subheadline)
               .fontWeight(.medium)

            Button(action: createDemoCategories) {
               HStack {
                  Image(systemName: "wand.and.stars")
                  Text("Create Demo Categories")
               }
            }
            .buttonStyle(.bordered)
            .disabled(!categoryManager.categories.isEmpty)
            
            if !categoryManager.categories.isEmpty {
               Text("Demo categories already exist or categories are configured")
                  .font(.caption)
                  .foregroundColor(.secondary)
            }
         }
         .padding(.horizontal, 4)

         Divider()

         ScrollView {
            // List of categories
            VStack(alignment: .leading, spacing: 12) {
               Text(L10n.manageCategories)
                  .font(.subheadline)
                  .fontWeight(.medium)

               if categoryManager.categories.isEmpty {
                  Text(L10n.noCategories)
                     .font(.subheadline)
                     .foregroundColor(.secondary)
                     .padding(.vertical, 8)
               } else {
                  ForEach(categoryManager.categories) { category in
                     CategoryRow(category: category, onDelete: {
                        categoryToDelete = category
                        showDeleteAlert = true
                     })
                  }
               }
            }
         }
      }
      .alert(L10n.deleteCategoryTitle, isPresented: $showDeleteAlert) {
         Button(L10n.cancel, role: .cancel) {
            categoryToDelete = nil
         }
         Button(L10n.deleteCategory, role: .destructive) {
            if let category = categoryToDelete {
               categoryManager.deleteCategory(category: category)
            }
            categoryToDelete = nil
         }
      } message: {
         Text(L10n.deleteCategoryMessage)
      }
   }

   private func createCategory() {
      guard !newCategoryName.isEmpty else { return }
      categoryManager.createCategory(name: newCategoryName)
      newCategoryName = ""
   }
   
   private func createDemoCategories() {
      // Get all apps from AppManager
      let allApps = appManager.pages.flatMap { $0 }.compactMap { item -> AppInfo? in
         if case .app(let app) = item {
            return app
         }
         return nil
      }
      
      // Create Productivity category
      let productivityCategory = categoryManager.createCategory(name: "Productivity")
      let productivityKeywords = ["mail", "calendar", "notes", "reminders", "contacts", "pages", "numbers", "keynote", "preview", "textedit"]
      for app in allApps {
         if productivityKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: productivityCategory.id)
         }
      }
      
      // Create Development category
      let developmentCategory = categoryManager.createCategory(name: "Development")
      let developmentKeywords = ["xcode", "terminal", "simulator", "instruments", "console"]
      for app in allApps {
         if developmentKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: developmentCategory.id)
         }
      }
      
      // Create Media category
      let mediaCategory = categoryManager.createCategory(name: "Media")
      let mediaKeywords = ["music", "tv", "podcasts", "photos", "quicktime", "imovie", "garageband"]
      for app in allApps {
         if mediaKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: mediaCategory.id)
         }
      }
      
      // Create Utilities category
      let utilitiesCategory = categoryManager.createCategory(name: "Utilities")
      let utilitiesKeywords = ["calculator", "dictionary", "font book", "activity monitor", "disk utility", "system settings"]
      for app in allApps {
         if utilitiesKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: utilitiesCategory.id)
         }
      }
      
      // Create Web Browsers category
      let browsersCategory = categoryManager.createCategory(name: "Web Browsers")
      let browserKeywords = ["safari", "chrome", "firefox", "edge", "brave"]
      for app in allApps {
         if browserKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: browsersCategory.id)
         }
      }
      
      // Create Communication category
      let communicationCategory = categoryManager.createCategory(name: "Communication")
      let communicationKeywords = ["messages", "facetime", "slack", "teams", "zoom", "discord"]
      for app in allApps {
         if communicationKeywords.contains(where: { app.name.lowercased().contains($0) }) {
            categoryManager.addAppToCategory(appPath: app.path, categoryId: communicationCategory.id)
         }
      }
   }
}

struct CategoryRow: View {
   let category: Category
   let onDelete: () -> Void

   private let categoryManager = CategoryManager.shared
   @State private var isEditing = false
   @State private var editedName: String

   init(category: Category, onDelete: @escaping () -> Void) {
      self.category = category
      self.onDelete = onDelete
      _editedName = State(initialValue: category.name)
   }

   var body: some View {
      HStack {
         if isEditing {
            TextField(L10n.categoryName, text: $editedName)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .onSubmit {
                  saveEdit()
               }

            Button(L10n.apply) {
               saveEdit()
            }
            .buttonStyle(.bordered)

            Button(L10n.cancel) {
               editedName = category.name
               isEditing = false
            }
            .buttonStyle(.bordered)
         } else {
            Image(systemName: "tag.fill")
               .foregroundColor(.blue)

            Text(category.name)
               .font(.body)

            Text("(\(category.appPaths.count))")
               .font(.caption)
               .foregroundColor(.secondary)

            Spacer()

            Button(action: { isEditing = true }) {
               Image(systemName: "pencil")
            }
            .buttonStyle(.borderless)

            Button(action: onDelete) {
               Image(systemName: "trash")
                  .foregroundColor(.red)
            }
            .buttonStyle(.borderless)
         }
      }
      .padding(.vertical, 4)
   }

   private func saveEdit() {
      if !editedName.isEmpty {
         categoryManager.renameCategory(category: category, newName: editedName)
      } else {
         editedName = category.name
      }
      isEditing = false
   }
}
