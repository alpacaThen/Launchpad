import SwiftUI

struct CategorySettings: View {
   @ObservedObject private var categoryManager = CategoryManager.shared
   @ObservedObject private var appManager = AppManager.shared

   @State private var newCategoryName = ""
   @State private var showDeleteAlert = false
   @State private var categoryToDelete: Category?

   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 20) {
            Text(L10n.categories)
               .font(.headline)

            Text(L10n.categoriesDescription)
               .font(.subheadline)
               .foregroundColor(.secondary)

            Divider()

            // Create new category
            VStack(alignment: .leading, spacing: 12) {
               Text(L10n.createCategory)
                  .font(.subheadline)
                  .fontWeight(.medium)

               HStack {
                  TextField(L10n.categoryName, text: $newCategoryName)
                     .textFieldStyle(RoundedBorderTextFieldStyle())

                  Button(action: createCategory) {
                     Image(systemName: "plus.circle.fill")
                        .font(.title2)
                  }
                  .buttonStyle(.borderless)
                  .disabled(newCategoryName.isEmpty)
               }
            }

            Divider()

            // List of categories
            VStack(alignment: .leading, spacing: 12) {
               Text(L10n.manageCategories)
                  .font(.subheadline)
                  .fontWeight(.medium)

               if categoryManager.categories.isEmpty {
                  Text(L10n.noCategories)
                     .font(.subheadline)
                     .foregroundColor(.secondary)
                     .padding(.vertical, 8)
               } else {
                  ForEach(categoryManager.categories) { category in
                     CategoryRow(category: category, onDelete: {
                        categoryToDelete = category
                        showDeleteAlert = true
                     })
                  }
               }
            }
         }
      }
      .alert(L10n.deleteCategoryTitle, isPresented: $showDeleteAlert) {
         Button(L10n.cancel, role: .cancel) {
            categoryToDelete = nil
         }
         Button(L10n.deleteCategory, role: .destructive) {
            if let category = categoryToDelete {
               categoryManager.deleteCategory(category)
            }
            categoryToDelete = nil
         }
      } message: {
         Text(L10n.deleteCategoryMessage)
      }
   }

   private func createCategory() {
      guard !newCategoryName.isEmpty else { return }
      _ = categoryManager.createCategory(name: newCategoryName)
      newCategoryName = ""
   }
}

struct CategoryRow: View {
   let category: Category
   let onDelete: () -> Void

   @ObservedObject private var categoryManager = CategoryManager.shared
   @State private var isEditing = false
   @State private var editedName: String

   init(category: Category, onDelete: @escaping () -> Void) {
      self.category = category
      self.onDelete = onDelete
      _editedName = State(initialValue: category.name)
   }

   var body: some View {
      HStack {
         if isEditing {
            TextField(L10n.categoryName, text: $editedName)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .onSubmit {
                  saveEdit()
               }

            Button(L10n.apply) {
               saveEdit()
            }
            .buttonStyle(.bordered)

            Button(L10n.cancel) {
               editedName = category.name
               isEditing = false
            }
            .buttonStyle(.bordered)
         } else {
            Image(systemName: "tag.fill")
               .foregroundColor(.blue)

            Text(category.name)
               .font(.body)

            Text("(\(category.appPaths.count))")
               .font(.caption)
               .foregroundColor(.secondary)

            Spacer()

            Button(action: { isEditing = true }) {
               Image(systemName: "pencil")
            }
            .buttonStyle(.borderless)

            Button(action: onDelete) {
               Image(systemName: "trash")
                  .foregroundColor(.red)
            }
            .buttonStyle(.borderless)
         }
      }
      .padding(.vertical, 4)
   }

   private func saveEdit() {
      if !editedName.isEmpty {
         categoryManager.renameCategory(category, newName: editedName)
      } else {
         editedName = category.name
      }
      isEditing = false
   }
}
