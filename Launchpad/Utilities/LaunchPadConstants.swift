import SwiftUI

/// Constants used throughout the LaunchPad application
class LaunchPadConstants {

   // MARK: - Animation Constants
   static let springAnimation = Animation.interpolatingSpring(stiffness: 300, damping: 100)
   static let fadeAnimation = Animation.easeInOut(duration: 0.3)
   static let jiggleAnimation = Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true)
   static let dragDropAnimationResponse: Double = 0.3
   static let dragDropAnimationDamping: Double = 2.8
   static let dragDropAnimation = Animation.spring(response: dragDropAnimationResponse, dampingFraction: dragDropAnimationDamping)

   // MARK: - Layout Constants
   static let folderPreviewSize = 9 // Apps shown in folder preview (3x3 grid)
   static let iconDisplaySize: CGFloat = 256
   static let folderCornerRadiusMultiplier: CGFloat = 0.2
   static let folderSizeMultiplier: CGFloat = 0.82
   static let categoryBoxSize: Int = 440

   // MARK: - Timing Constants
   static let hoverDelay: TimeInterval = 0.8

   // MARK: - UI Constants
   static let searchBarWidth: CGFloat = 480
   static let searchBarHeight: CGFloat = 36
   static let settingsWindowWidth: CGFloat = 1200
   static let settingsWindowHeight: CGFloat = 800
   static let pageIndicatorSize: CGFloat = 10
   static let pageIndicatorActiveScale: CGFloat = 1.2
   static let pageIndicatorSpacing: CGFloat = 20
   static let dropZoneWidth: CGFloat = 60

   // MARK: - Scale Constants
   static let hoveredItemScale: CGFloat = 1.1
   static let draggedItemScale: CGFloat = 1.1
   static let folderCreationScale: CGFloat = 1.2

   // MARK: - Edit Mode Constants
   static let jiggleRotation: Double = 4.0  // degrees
}
