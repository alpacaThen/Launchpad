import Foundation

enum SortOrder: String, Codable, CaseIterable {
   case defaultLayout = "default"
   case name = "name"
   
   var displayName: String {
      switch self {
      case .defaultLayout:
         return L10n.sortByDefault
      case .name:
         return L10n.sortByName
      }
   }
}
