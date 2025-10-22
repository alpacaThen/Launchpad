   @ViewBuilder
   private func gridContent(layout: LayoutMetrics) -> some View {
      ForEach(Array(apps.enumerated()), id: \.element.id) { index, app in
         AppIconView(app: app, layout: layout, isDragged: false)
            .id(app.id)
            .background(
               RoundedRectangle(cornerRadius: 12)
                  .fill(index == selectedIndex ? Color.gray.opacity(0.3) : Color.clear)
                  .padding(-8)
                  .aspectRatio(1.0, contentMode: .fit)
            )
            .onTapGesture {
               onItemTap(.app(app))
            }
            .contextMenu {
               CategoryContextMenu(app: app)
               
               Divider()
               
               Button(action: {
                  AppManager.shared.hideApp(path: app.path, appsPerPage: settings.appsPerPage)
               }) {
                  Label(L10n.hideApp, systemImage: "eye.slash")
               }
            }
      }
   }