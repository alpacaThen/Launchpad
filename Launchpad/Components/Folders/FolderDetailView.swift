import SwiftUI

struct FolderDetailView: View {
   @Binding var pages: [[AppGridItem]]
   @Binding var folder: Folder?
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void
   
   @State private var editingName = false
   @State private var draggedApp: AppInfo?
   @State private var isAnimatingIn = false
   @State private var opacity: Double = 0
   @State private var headerOffset: CGFloat = -20
   
   var body: some View {
      if folder != nil {
         ZStack {
            Color.clear
               .contentShape(Rectangle())
               .onDrop(
                  of: [.text],
                  delegate: RemoveDropDelegate(pages: $pages, folder: Binding(get: { folder! }, set: { folder = $0 }), draggedApp: $draggedApp, appsPerPage: settings.appsPerPage)
               )
               .onTapGesture {
                  dismissWithAnimation()
               }
            
            VStack(spacing: 10) {
               FolderNameView(folder: Binding(get: { folder! }, set: { folder = $0 }), editingName: $editingName, opacity: opacity, offset: headerOffset)
               GeometryReader { geo in
                  let layout = LayoutMetrics(size: geo.size, columns: settings.folderColumns, rows: settings.folderRows + 1, iconSize: settings.iconSize)
                  
                  ScrollView(.vertical, showsIndicators: false) {
                     LazyVGrid(
                        columns: GridLayoutUtility.createGridColumns(count: settings.folderColumns, cellWidth: layout.cellWidth, spacing: layout.hSpacing),
                        spacing: layout.vSpacing
                     ) {
                        ForEach(folder!.apps) { app in
                           AppIconView(app: app, layout: layout, isDragged: draggedApp?.id == app.id, isEditMode: false, isHovered: false)
                              .onTapGesture { onItemTap(.app(app))  }
                              .onDrag {
                                 withAnimation(.easeOut(duration: 0.15)) {
                                    draggedApp = app
                                 }
                                 return NSItemProvider(object: app.id.uuidString as NSString)
                              }
                              .onDrop(
                                 of: [.text],
                                 delegate: FolderDropDelegate(
                                    folder: Binding(get: { self.folder! }, set: { self.folder = $0 }),
                                    draggedApp: $draggedApp,
                                    dropDelay: settings.dropDelay,
                                    targetApp: app
                                 ))
                        }
                     }
                     .padding(.vertical, 20)
                  }
                  .scrollBounceBehavior(.basedOnSize)
               }
               .opacity(opacity)
            }
            .frame(width: LaunchPadConstants.settingsWindowWidth, height: LaunchPadConstants.settingsWindowHeight)
            .background(FolderBackground(transparency: settings.transparency))
            .shadow(color: .black.opacity(0.15 * settings.transparency), radius: 40, x: 0, y: 20)
            .shadow(color: .black.opacity(0.1 * settings.transparency), radius: 10, x: 0, y: 5)
            .scaleEffect(isAnimatingIn ? 1.0 : 0.85)
            .opacity(isAnimatingIn ? 1.0 : 0.0)
            .onAppear {
               performEntranceAnimation()
            }
            .onTapGesture { editingName = false }
         }
      }
   }
   
   private func performEntranceAnimation() {
      withAnimation(.interpolatingSpring(stiffness: 280, damping: 22)) {
         isAnimatingIn = true
      }
      
      withAnimation(.easeOut(duration: 0.3)) {
         opacity = 1.0
      }
      
      withAnimation(.interpolatingSpring(stiffness: 300, damping: 25)) {
         headerOffset = 0
      }
   }
   
   private func dismissWithAnimation() {
      withAnimation(.easeIn(duration: 0.1)) {
         opacity = 0
         headerOffset = -20
         isAnimatingIn = false
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         saveFolder()
      }
   }
   
   private func saveFolder() {
      guard let pageIndex = pages.firstIndex(where: { page in page.contains(where: { $0.id == folder!.id }) }),
            let itemIndex = pages[pageIndex].firstIndex(where: { $0.id == folder!.id }) else {
         return
      }
      let newFolder = Folder(name: folder!.name, page: folder!.page, apps: folder!.apps)
      pages[pageIndex][itemIndex] = .folder(newFolder)
      folder = nil
      AppManager.shared.saveGridItems()
   }
}
