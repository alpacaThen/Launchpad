import SwiftUI

struct CategoryPageView: View {
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void

   @ObservedObject private var categoryManager = CategoryManager.shared

   var body: some View {
      if categoryManager.categories.isEmpty {
         EmptyCategoriesView()
      } else {
         GeometryReader { geo in
            let layout = LayoutMetrics(size: geo.size, columns: settings.columns, rows: settings.rows, iconSize: settings.iconSize)
            ScrollView(.vertical, showsIndicators: false) {
               VStack(spacing: 24) {
                  LazyVGrid(
                     columns: GridLayoutUtility.createFlexibleGridColumns(count: Int(geo.size.width) / LaunchPadConstants.categoryBoxSize, spacing: 36),
                     spacing: 36
                  ) {
                     ForEach(categoryManager.categories) { category in
                        CategoryBoxView(
                           category: category,
                           allApps: allApps,
                           settings: settings,
                           layout: layout,
                           onItemTap: onItemTap
                        )
                     }
                  }
                  .padding(.horizontal, layout.hPadding)
                  .padding(.vertical, layout.vPadding)
               }
               .scrollBounceBehavior(.basedOnSize)
               .padding(.horizontal, 72)
            }
         }
      }
   }
}
