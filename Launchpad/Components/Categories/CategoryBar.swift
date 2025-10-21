import SwiftUI

struct CategoryBar: View {
   @ObservedObject private var categoryManager = CategoryManager.shared
   @Binding var selectedCategory: Category?
   let transparency: Double

   var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
         HStack(spacing: 12) {
            ForEach(categoryManager.categories) { category in
               CategoryFilterButton(name: category.name, isSelected: selectedCategory?.id == category.id,transparency: transparency) {
                  selectedCategory = category
               }
            }
         }
         .padding(.horizontal, 56)
      }
      .frame(height: 40)
   }
}
