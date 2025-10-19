import Foundation

enum AppGridItem: Identifiable, Equatable {
   case app(AppInfo)
   case folder(Folder)
   case category(Category)

   var id: UUID {
      switch self {
      case .app(let app):
         return app.id
      case .folder(let folder):
         return folder.id
      case .category(let category):
         return category.id
      }
   }

   var page: Int {
      switch self {
      case .app(let app):
         return app.page
      case .folder(let folder):
         return folder.page
      case .category:
         return 0
      }
   }

   var name: String {
      switch self {
      case .app(let app):
         return app.name
      case .folder(let folder):
         return folder.name
      case .category(let category):
         return category.name
      }
   }

   var isFolder: Bool {
      switch self {
      case .app:
         return false
      case .folder:
         return true
      case .category:
         return false
      }
   }

   var appInfo: AppInfo? {
      switch self {
      case .app(let app):
         return app
      case .folder:
         return nil
      case .category:
         return nil
      }
   }

   var folder: Folder? {
      switch self {
      case .app:
         return nil
      case .folder(let folder):
         return folder
      case .category:
         return nil
      }
   }

   var category: Category? {
      switch self {
      case .app:
         return nil
      case .folder:
         return nil
      case .category(let category):
         return category
      }
   }

   static func == (lhs: AppGridItem, rhs: AppGridItem) -> Bool {
      lhs.id == rhs.id
   }
}
