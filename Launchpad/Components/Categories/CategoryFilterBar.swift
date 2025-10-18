import SwiftUI

struct CategoryFilterBar: View {
   @ObservedObject private var categoryManager = CategoryManager.shared
   @Binding var selectedCategory: Category?
   let transparency: Double
   
   var body: some View {
      if !categoryManager.categories.isEmpty {
         ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
               // "All Apps" button
               CategoryFilterButton(
                  name: L10n.allApps,
                  isSelected: selectedCategory == nil,
                  transparency: transparency
               ) {
                  selectedCategory = nil
               }
               
               // Individual category buttons
               ForEach(categoryManager.categories) { category in
                  CategoryFilterButton(
                     name: category.name,
                     isSelected: selectedCategory?.id == category.id,
                     transparency: transparency
                  ) {
                     selectedCategory = category
                  }
               }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
         }
         .frame(height: 44)
         .background(.ultraThinMaterial.opacity(0.6 * transparency))
      }
   }
}

struct CategoryFilterButton: View {
   let name: String
   let isSelected: Bool
   let transparency: Double
   let action: () -> Void
   
   var body: some View {
      Button(action: action) {
         Text(name)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(
               RoundedRectangle(cornerRadius: 16)
                  .fill(isSelected ? Color.accentColor.opacity(0.8 * transparency) : Color.primary.opacity(0.1 * transparency))
            )
            .foregroundColor(isSelected ? .white : .primary)
      }
      .buttonStyle(.plain)
   }
}
