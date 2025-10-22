import SwiftUI

struct CategoryPageView: View {
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void

   @ObservedObject private var categoryManager = CategoryManager.shared
   @Environment(\.colorScheme) private var colorScheme

   var body: some View {
      GeometryReader { geo in
         ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
               LazyVGrid(
                  columns: [
                     GridItem(.flexible(), spacing: 24),
                     GridItem(.flexible(), spacing: 24)
                  ],
                  spacing: 24
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
               .padding(.horizontal, 32)
            }
            .frame(minHeight: geo.size.height, alignment: .top)
         }
         .scrollBounceBehavior(.basedOnSize)
      }
   }
}
