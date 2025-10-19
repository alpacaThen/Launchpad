import SwiftUI

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
               RoundedRectangle(cornerRadius: 6)
                  .fill(isSelected ? Color.accentColor.opacity(0.8 * transparency) : Color.primary.opacity(0.1 * transparency))
            )
            .foregroundColor(isSelected ? .white : .primary)
      }
      .buttonStyle(.plain)
   }
}
