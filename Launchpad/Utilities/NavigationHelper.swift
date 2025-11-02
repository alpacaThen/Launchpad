import Foundation

struct NavigationHelper {
   static func navigateLeft(currentIndex: Int, itemCount: Int) -> Int {
      guard itemCount > 0 else { return currentIndex }

      if currentIndex > 0 {
         return currentIndex - 1
      } else {
         return itemCount - 1
      }
   }

   static func navigateRight(currentIndex: Int, itemCount: Int) -> Int {
      guard itemCount > 0 else { return currentIndex }

      if currentIndex < itemCount - 1 {
         return currentIndex + 1
      } else {
         return 0
      }
   }

   static func navigateUp(currentIndex: Int, itemCount: Int, columns: Int) -> Int {
      guard itemCount > 0, columns > 0 else { return currentIndex }

      let newIndex = currentIndex - columns
      if newIndex >= 0 {
         return newIndex
      } else {
         // Wrap to bottom row
         let lastRowStartIndex = (itemCount - 1) / columns * columns
         let columnOffset = currentIndex % columns
         return min(lastRowStartIndex + columnOffset, itemCount - 1)
      }
   }

   static func navigateDown(currentIndex: Int, itemCount: Int, columns: Int) -> Int {
      guard itemCount > 0, columns > 0 else { return currentIndex }

      let newIndex = currentIndex + columns
      if newIndex < itemCount {
         return newIndex
      } else {
         // Wrap to top row
         let columnOffset = currentIndex % columns
         return min(columnOffset, itemCount - 1)
      }
   }
}
