import SwiftUI

struct GridItemView: View {
    let item: AppGridItem
    let layout: LayoutMetrics
    let isDragged: Bool
    let isDraggedOn: Bool
    let isHovered: Bool
    let isEditMode: Bool
    let settings: LaunchpadSettings
    
    @State private var jiggleRotation: Double = 0
    
    var body: some View {
        Group {
            switch item {
            case .app(let app):
                AppIconView(app: app, layout: layout, isDragged: isDragged, isDraggedOn: isDraggedOn, isHovered: isHovered)
            case .folder(let folder):
                FolderIconView(folder: folder, layout: layout, isDragged: isDragged, isDraggedOn: isDraggedOn, isHovered: isHovered, transparency: settings.transparency)
            case .category:
                EmptyView()  // Categories are not displayed as grid items
            }
        }
        .rotationEffect(.degrees(isEditMode ? jiggleRotation - (LaunchPadConstants.jiggleRotation / 2) : 0))
        .animation(isDragged ? .easeInOut(duration: 0.2) : LaunchPadConstants.springAnimation, value: isDragged)
        .animation(LaunchPadConstants.springAnimation, value: isHovered)
        .animation(LaunchPadConstants.jiggleAnimation, value: jiggleRotation)
        .onChange(of: isEditMode) { newValue in handleJiggling(isEditMode: newValue) }
    }
    
    private func handleJiggling(isEditMode: Bool) {
        if(isEditMode)
        {
            jiggleRotation = LaunchPadConstants.jiggleRotation
        }
        else
        {
            jiggleRotation = 0
        }
    }
}
