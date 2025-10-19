import SwiftUI

struct CategoryContextMenu: View {
   let app: AppInfo

   @ObservedObject private var categoryManager = CategoryManager.shared

   var appCategories: [Category] {
      categoryManager.getCategoriesForApp(appPath: app.path)
   }

   var body: some View {
      if !categoryManager.categories.isEmpty {
         Menu {
            ForEach(categoryManager.categories) { category in
               let isInCategory = appCategories.contains { $0.id == category.id }
               Button(action: {
                  if isInCategory {
                     categoryManager.removeAppFromCategory(appPath: app.path, categoryId: category.id)
                  } else {
                     categoryManager.addAppToCategory(appPath: app.path, categoryId: category.id)
                  }
               }) {
                  Label(category.name, systemImage: isInCategory ? "checkmark" : "tag")
               }
            }
         } label: {
            Label(L10n.manageCategories, systemImage: "tag.fill")
         }
      }
   }
}
