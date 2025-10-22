import SwiftUI

struct EmptyCategoriesView: View {
   var body: some View {
      VStack {
         Spacer()
         Image(systemName: "folder.badge.plus")
            .font(.system(size: 48))
            .foregroundColor(.gray.opacity(0.8))
         Text(L10n.noCategoriesTitle)
            .font(.title2)
            .foregroundColor(.gray.opacity(0.8))
            .padding(.top, 10)
         Text(L10n.noCategoriesSubtitle)
            .font(.subheadline)
            .foregroundColor(.gray.opacity(0.6))
            .padding(.top, 4)
         Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
   }
}
