import SwiftUI

struct SettingsColorPicker: View {
   let title: String
   @Binding var hexColor: String?
   let defaultColor: String
   
   @State private var selectedColor: Color
   
   init(title: String, hexColor: Binding<String?>, defaultColor: String = "FFFFFF") {
      self.title = title
      self._hexColor = hexColor
      self.defaultColor = defaultColor
      self._selectedColor = State(initialValue: Color(hex: hexColor.wrappedValue ?? defaultColor))
   }
   
   var body: some View {
      HStack(spacing: 12) {
         Text(title)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
            .frame(width: 140, alignment: .leading)
         
         ColorPicker("", selection: $selectedColor, supportsOpacity: false)
            .labelsHidden()
            .onChange(of: selectedColor) { _, newColor in
               if let hex = newColor.toHex() {
                  hexColor = hex
               }
            }
         
         Text("#\(hexColor ?? defaultColor)")
            .font(.system(size: 12, design: .monospaced))
            .foregroundColor(.secondary)
            .frame(width: 70, alignment: .leading)
         
         Button(action: {
            hexColor = nil
            selectedColor = Color(hex: defaultColor)
         }) {
            Image(systemName: "xmark.circle.fill")
               .foregroundColor(.secondary)
               .opacity(hexColor == nil ? 0.3 : 1.0)
         }
         .buttonStyle(.plain)
         .disabled(hexColor == nil)
         .help("Reset to default")
      }
      .padding(.vertical, 4)
   }
}
