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
      Array(categoryApps.prefix(4))
   }
   
   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         // Category name
         Text(category.name)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.primary)
            .padding(.leading, 12)
            .padding(.top, 12)
         
         // Apps grid
         VStack(spacing: 8) {
            HStack(spacing: 8) {
               ForEach(previewApps.prefix(2)) { app in
                  appButton(for: app)
               }
               if previewApps.count < 2 {
                  ForEach(0..<(2 - previewApps.count), id: \.self) { _ in
                     placeholderBox()
                  }
               }
            }
            
            HStack(spacing: 8) {
               if previewApps.count > 2 {
                  ForEach(previewApps.dropFirst(2)) { app in
                     appButton(for: app)
                  }
               }
               if previewApps.count < 4 {
                  ForEach(0..<(4 - previewApps.count), id: \.self) { _ in
                     placeholderBox()
                  }
               }
            }
         }
         .padding(.horizontal, 12)
         .padding(.bottom, 12)
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
         VStack(spacing: 4) {
            Image(nsImage: app.icon)
               .interpolation(.high)
               .antialiased(true)
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 48, height: 48)
               .cornerRadius(8)
            
            Text(app.name)
               .font(.system(size: 10))
               .lineLimit(1)
               .foregroundColor(.primary)
         }
         .frame(maxWidth: .infinity)
         .padding(8)
         .background(
            RoundedRectangle(cornerRadius: 12)
               .fill(Color.primary.opacity(0.05 * settings.transparency))
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
