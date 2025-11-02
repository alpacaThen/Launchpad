import AppKit
import SwiftUI

struct AppIconView: View {
    let app: AppInfo
    let layout: LayoutMetrics
    let isDragged: Bool
    let isDraggedOn: Bool
    let isHovered: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(nsImage: app.icon)
                .interpolation(.high)
                .antialiased(true)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: layout.iconSize, height: layout.iconSize)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)

            Text(app.name)
                .font(.system(size: layout.fontSize))
                .multilineTextAlignment(.center)
                .frame(width: layout.cellWidth)
        }
        .scaleEffect(scaleEffect)
        //.animation(LaunchPadConstants.fadeAnimation, value: isDragged)
        .contextMenu {
            CategoryContextMenu(app: app)

            Divider()

            Button(action: { AppManager.shared.hideApp(path: app.path) }) {
                Label(L10n.hideApp, systemImage: "eye.slash")
            }
        }
    }

    private var scaleEffect: CGFloat {
        if isDragged {
            return LaunchPadConstants.draggedItemScale
        } else if isDraggedOn {
            return LaunchPadConstants.folderCreationScale
        } else if isHovered {
            return LaunchPadConstants.hoveredItemScale
        }
        return 1.0
    }
}
