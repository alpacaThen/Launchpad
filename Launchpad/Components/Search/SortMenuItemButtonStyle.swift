import SwiftUI

struct SortMenuItemButtonStyle: ButtonStyle {
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .background(
            Rectangle()
               .fill(configuration.isPressed ? Color.primary.opacity(0.08) : Color.primary.opacity(0.03))
         )
   }
}
