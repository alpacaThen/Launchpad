import SwiftUI

struct FolderBackground: View {
   let transparency: Double
   
   @Environment(\.colorScheme) private var colorScheme
   
   var body: some View {
      RoundedRectangle(cornerRadius: 20)
         .fill(.regularMaterial.opacity(0.75))
         .overlay(
            RoundedRectangle(cornerRadius: 20)
               .fill(
                  LinearGradient(
                     colors: [
                        Color.white.opacity((colorScheme == .dark ? 0.1 : 0.3) * transparency),
                        Color.white.opacity(0.05 * transparency)
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
                        Color.white.opacity((colorScheme == .dark ? 0.3 : 0.5) * transparency),
                        Color.white.opacity(0.1 * transparency)
                     ],
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing
                  ),
                  lineWidth: 1
               )
         )
   }
}
