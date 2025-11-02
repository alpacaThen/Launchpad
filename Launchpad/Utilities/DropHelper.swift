import SwiftUI

@MainActor
struct DropHelper {
   static func performDelayedMove(
      delay: Double = 0.5,
      animation: Animation = LaunchPadConstants.easeInOutAnimation,
      action: @escaping () -> Void
   ) {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
         withAnimation(animation) {
            action()
         }
      }
   }
   
   static func calculateMoveOffset(fromIndex: Int, toIndex: Int) -> Int {
      return toIndex > fromIndex ? toIndex + 1 : toIndex
   }
}
