import SwiftUI

struct CategoryBoxView: View {
   let category: Category
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void
   let onCategoryTap: () -> Void
   
   @Environment(\.colorScheme) private var colorScheme
   
   private var categoryApps: [AppInfo] {
      CategoryManager.shared.getAppsForCategory(category: category, from: allApps)
   }
   
   private var previewApps: [AppInfo] {
      Array(categoryApps.prefix(9))
   }
   
   var body: some View {
      VStack(alignment: .leading, spacing: 12) {
         // Category name
         Text(category.name)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary)
            .padding(.leading, 16)
            .padding(.top, 16)
         
         // Apps grid - 3x3 layout like iOS App Library
         LazyVGrid(
            columns: [
               GridItem(.flexible(), spacing: 8),
               GridItem(.flexible(), spacing: 8),
               GridItem(.flexible(), spacing: 8)
            ],
            spacing: 8
         ) {
            ForEach(previewApps) { app in
               appButton(for: app)
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
                           Color.white.opacity(0.05 * settings.transparency)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                     )
                  )
            )
            .overlay(
               RoundedRectangle(cornerRadius: 20)
                  .stroke(
                     LinearGradient(
                        colors: [
                           Color.white.opacity((colorScheme == .dark ? 0.3 : 0.5) * settings.transparency),
                           Color.white.opacity(0.1 * settings.transparency)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                     ),
                     lineWidth: 1
                  )
            )
      )
      .shadow(color: .black.opacity(0.15 * settings.transparency), radius: 20, x: 0, y: 10)
      .shadow(color: .black.opacity(0.1 * settings.transparency), radius: 10, x: 0, y: 5)
      .contentShape(Rectangle())
      .onTapGesture {
         if categoryApps.isEmpty {
            // Do nothing if category is empty
         } else {
            onCategoryTap()
         }
      }
   }
   
   private func appButton(for app: AppInfo) -> some View {
      Button(action: {
         onItemTap(.app(app))
      }) {
         VStack(spacing: 6) {
            Image(nsImage: app.icon)
               .interpolation(.high)
               .antialiased(true)
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 56, height: 56)
               .cornerRadius(10)
            
            Text(app.name)
               .font(.system(size: 11))
               .lineLimit(2)
               .multilineTextAlignment(.center)
               .foregroundColor(.primary)
               .frame(height: 28)
         }
         .frame(maxWidth: .infinity)
         .padding(10)
         .background(
            RoundedRectangle(cornerRadius: 14)
               .fill(Color.primary.opacity(0.06 * settings.transparency))
         )
      }
      .buttonStyle(.plain)
   }
   
   private func placeholderBox() -> some View {
      RoundedRectangle(cornerRadius: 12)
         .fill(Color.clear)
         .frame(maxWidth: .infinity)
         .aspectRatio(1, contentMode: .fit)
   }
}
