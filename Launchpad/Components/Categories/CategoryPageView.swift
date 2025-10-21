import SwiftUI

struct CategoryPageView: View {
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void
   
   @ObservedObject private var categoryManager = CategoryManager.shared
   @Environment(\.colorScheme) private var colorScheme
   
   var body: some View {
      GeometryReader { geo in
         let layout = LayoutMetrics(size: geo.size, columns: 2, rows: 3, iconSize: settings.iconSize)
         
         ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(
               columns: GridLayoutUtility.createGridColumns(count: 2, cellWidth: layout.cellWidth * 2, spacing: layout.hSpacing * 2),
               spacing: layout.vSpacing * 2
            ) {
               ForEach(categoryManager.categories) { category in
                  CategoryBoxView(
                     category: category,
                     allApps: allApps,
                     settings: settings,
                     onItemTap: onItemTap,
                     onCategoryTap: {
                        onItemTap(.category(category))
                     }
                  )
               }
            }
            .padding(.horizontal, layout.hPadding)
            .padding(.vertical, layout.vPadding)
            .frame(minHeight: geo.size.height, alignment: .top)
         }
         .scrollBounceBehavior(.basedOnSize)
      }
   }
}
