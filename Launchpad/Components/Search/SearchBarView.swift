import SwiftUI

struct SearchBarView: View {
   var searchText: String
   var transparency: Double
   var onSortOrderChange: ((SortOrder) -> Void)?
   var onSettingsOpen: (() -> Void)?
   @Binding var currentSortOrder: SortOrder
   
   @State private var showSortMenu = false
   
   var body: some View {
      HStack(spacing: 12) {
         Spacer()
         
         // Sort button
         Button(action: { showSortMenu.toggle() }) {
            Image(systemName: "arrow.up.arrow.down")
               .font(.system(size: 16, weight: .medium))
               .foregroundColor(.white)
               .frame(width: 36, height: 36)
               .background(
                  Circle()
                     .fill(Color(NSColor.windowBackgroundColor).opacity(0.4 * transparency))
               )
               .shadow(color: Color.black.opacity(0.2 * transparency), radius: 10, x: 0, y: 3)
         }
         .buttonStyle(.plain)
         .popover(isPresented: $showSortMenu, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 8) {
               ForEach(SortOrder.allCases, id: \.self) { order in
                  Button(action: {
                     currentSortOrder = order
                     onSortOrderChange?(order)
                     showSortMenu = false
                  }) {
                     HStack {
                        Text(order.displayName)
                           .foregroundColor(.primary)
                        Spacer()
                        if currentSortOrder == order {
                           Image(systemName: "checkmark")
                              .foregroundColor(.blue)
                        }
                     }
                     .padding(.horizontal, 12)
                     .padding(.vertical, 6)
                  }
                  .buttonStyle(.plain)
               }
            }
            .padding(8)
            .frame(minWidth: 200)
         }
         
         // Search bar
         Text(searchText.isEmpty ? L10n.searchPlaceholder : searchText)
            .textFieldStyle(.plain)
            .font(.system(size: 16, weight: .regular))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(width: LaunchPadConstants.searchBarWidth, height: LaunchPadConstants.searchBarHeight)
            .background(
               RoundedRectangle(cornerRadius: 24, style: .continuous)
                  .fill(Color(NSColor.windowBackgroundColor).opacity(0.4 * transparency))
            )
            .shadow(color: Color.black.opacity(0.2 * transparency), radius: 10, x: 0, y: 3)
         
         // Settings button
         Button(action: { onSettingsOpen?() }) {
            Image(systemName: "gearshape.fill")
               .font(.system(size: 16, weight: .medium))
               .foregroundColor(.white)
               .frame(width: 36, height: 36)
               .background(
                  Circle()
                     .fill(Color(NSColor.windowBackgroundColor).opacity(0.4 * transparency))
               )
               .shadow(color: Color.black.opacity(0.2 * transparency), radius: 10, x: 0, y: 3)
         }
         .buttonStyle(.plain)
         
         Spacer()
      }
      .padding(.top, 40)
   }
}
