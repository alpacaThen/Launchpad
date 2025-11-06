import SwiftUI

struct PageDropDelegate: DropDelegate {
   @Binding var pages: [[AppGridItem]]
   @Binding var draggedItem: AppGridItem?
   let targetPage: Int
   let appsPerPage: Int
   let canEdit: Bool

   func performDrop(info: DropInfo) -> Bool {
      guard let draggedItem = draggedItem else { return false }
      guard canEdit else { return false }

      moveItemToEndOfPage(draggedItem: draggedItem)
      
      PageOverflowHelper.handleOverflow(pages: &pages, pageIndex: targetPage, appsPerPage: appsPerPage)
      AppManager.shared.saveAppGridItems()

      self.draggedItem = nil
      return true
   }

   private func moveItemToEndOfPage(draggedItem: AppGridItem) {
      guard let (currentPageIndex, currentItemIndex) = findItemLocation(item: draggedItem) else { return }

      withAnimation(LaunchpadConstants.dragDropAnimation) {
         pages[currentPageIndex].remove(at: currentItemIndex)
         pages[targetPage].append(draggedItem.withUpdatedPage(targetPage))
      }
   }

   private func findItemLocation(item: AppGridItem) -> (pageIndex: Int, itemIndex: Int)? {
      for (pageIndex, page) in pages.enumerated() {
         if let itemIndex = page.firstIndex(where: { $0.id == item.id }) {
            return (pageIndex, itemIndex)
         }
      }
      return nil
   }

   func dropUpdated(info: DropInfo) -> DropProposal? {
      return DropProposal(operation: .move)
   }
}
