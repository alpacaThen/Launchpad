import SwiftUI

struct CategoryIconView: View {
   let category: Category
   let allApps: [AppInfo]
   let layout: LayoutMetrics
   
   var categoryApps: [AppInfo] {
      CategoryManager.shared.getAppsForCategory(category, from: allApps)
   }
   
   var previewApps: [AppInfo] {
      Array(categoryApps.prefix(9))
   }
   
   var body: some View {
      VStack(spacing: layout.nameLabelSpacing) {
         ZStack {
            RoundedRectangle(cornerRadius: layout.iconCornerRadius)
               .fill(LinearGradient(
                  colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
               ))
            
            if previewApps.isEmpty {
               Image(systemName: "folder.badge.plus")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: layout.iconSize * 0.5, height: layout.iconSize * 0.5)
                  .foregroundColor(.white.opacity(0.8))
            } else {
               LazyVGrid(
                  columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                  spacing: 4
               ) {
                  ForEach(previewApps) { app in
                     Image(nsImage: app.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: layout.iconSize / 4, height: layout.iconSize / 4)
                        .cornerRadius(4)
                  }
               }
               .padding(8)
            }
         }
         .frame(width: layout.iconSize, height: layout.iconSize)
         
         Text(category.name)
            .font(.system(size: layout.nameLabelFontSize))
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(width: layout.cellWidth)
      }
   }
}
