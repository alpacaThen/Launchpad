import SwiftUI

struct CategoryBoxView: View {
   let category: Category
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let layout: LayoutMetrics
   let onItemTap: (AppGridItem) -> Void

   @Environment(\.colorScheme) private var colorScheme

   private var categoryApps: [AppInfo] {
      CategoryManager.shared.getAppsForCategory(category: category, from: allApps)
   }

   private var previewApps: [AppInfo] {
      Array(categoryApps.prefix(9))
   }

   var body: some View {
      VStack(alignment: .leading, spacing: 12) {
         Text(category.name)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary)
            .padding(.leading, 16)
            .padding(.top, 16)

         LazyVGrid(
            columns: GridLayoutUtility.createFlexibleGridColumns(count: 3, spacing: 12),
            spacing: 8
         ) {
            ForEach(previewApps) { app in
               AppIconView(app: app, layout: layout, scale: 1.0)
                  .onTapGesture { onItemTap(.app(app)) }
            }

            // Fill remaining spots with placeholders
            ForEach(0..<max(0, 9 - previewApps.count), id: \.self) { _ in
               placeholderBox()
            }
         }
         .padding(.horizontal, 16)
         .padding(.bottom, 16)
      }
      .background(
         RoundedRectangle(cornerRadius: 20)
            .fill(.regularMaterial.opacity(0.6 * settings.transparency))
            .overlay(
               RoundedRectangle(cornerRadius: 20)
                  .fill(
                     LinearGradient(
                        colors: [
                           Color.white.opacity((colorScheme == .dark ? 0.15 : 0.35) * settings.transparency),
                           Color.white.opacity(0.05 * settings.transparency),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                     )
                  )
            )
      )
      .contentShape(Rectangle())
      .onTapGesture {
         if !categoryApps.isEmpty {
            onItemTap(.category(category))
         }
      }
   }

   private func placeholderBox() -> some View {
      RoundedRectangle(cornerRadius: 12)
         .fill(Color.clear)
         .frame(maxWidth: .infinity)
         .aspectRatio(1, contentMode: .fit)
   }
}
