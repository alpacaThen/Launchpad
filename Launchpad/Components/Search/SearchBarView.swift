import SwiftUI

// TODO: Move this to SortMenuItemButtonStyle.swift once Xcode project sync is fixed
struct SortMenuItemButtonStyle: ButtonStyle {
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .background(
            Rectangle()
               .fill(configuration.isPressed ? Color.primary.opacity(0.08) : Color.primary.opacity(0.03))
         )
   }
}

struct SearchBarView: View {
   var searchText: String
   var transparency: Double
   var onSortOrderChange: ((SortOrder) -> Void)?
   var onSettingsOpen: (() -> Void)?
   @Binding var currentSortOrder: SortOrder

   @State private var showSortMenu = false
   @State private var hoveredItem: SortOrder?

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
            VStack(alignment: .leading, spacing: 0) {
               ForEach(SortOrder.allCases, id: \.self) { order in
                  Button(action: {
                     currentSortOrder = order
                     onSortOrderChange?(order)
                     showSortMenu = false
                  }) {
                     HStack(spacing: 12) {
                        Text(order.displayName)
                           .font(.system(size: 14))
                           .foregroundColor(.primary)
                        Spacer()
                        if currentSortOrder == order {
                           Image(systemName: "checkmark")
                              .font(.system(size: 13, weight: .semibold))
                              .foregroundColor(.blue)
                        }
                     }
                     .contentShape(Rectangle())
                     .padding(.horizontal, 16)
                     .padding(.vertical, 10)
                     .frame(maxWidth: .infinity, alignment: .leading)
                     .background(
                        Rectangle()
                           .fill(hoveredItem == order ? Color.primary.opacity(0.06) : Color.clear)
                     )
                  }
                  .buttonStyle(SortMenuItemButtonStyle())
                  .onHover { hovering in
                     withAnimation(.easeInOut(duration: 0.12)) {
                        hoveredItem = hovering ? order : nil
                     }
                  }
               }
            }
            .padding(.vertical, 4)
            .frame(minWidth: 220)
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
