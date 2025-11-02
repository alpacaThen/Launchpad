import SwiftUI

struct PageIndicatorView: View {
   
   @Binding var currentPage: Int
   let pageCount: Int
   let isFolderOpen: Bool
   let searchText: String
   let settings: LaunchpadSettings
   @Environment(\.colorScheme) private var colorScheme
   
   var body: some View {
      HStack(spacing: LaunchpadConstants.pageIndicatorSpacing) {
         ForEach(0..<pageCount, id: \.self) { index in
            Circle()
                  .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                  .frame(width: LaunchpadConstants.pageIndicatorSize, height: LaunchpadConstants.pageIndicatorSize)
                  .scaleEffect(index == currentPage ? LaunchpadConstants.pageIndicatorActiveScale : 1.0)
                  .animation(LaunchpadConstants.easeInOutAnimation, value: currentPage)
               .onTapGesture {
                  withAnimation(LaunchpadConstants.springAnimation) {
                     currentPage = index
                  }
               }
         }
      }
      .padding(.bottom, settings.showDock ? 120 : 40)
      .opacity(searchText.isEmpty && !isFolderOpen ? 1 : 0)
   }
}
