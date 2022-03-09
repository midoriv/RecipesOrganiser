//
//  EditView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 10/1/22.
//

import SwiftUI

struct EditView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var editMode: EditMode
    @State var recipe: ModifiableRecipe
    @State var customisePresented = false
    
    var body: some View {
        List {
            Section(header: Text("Recipe Name")) {
                TextField(text: $recipe.name, prompt: Text("Recipe Name")) {
                    Text(recipe.name)
                }
            }
            Section(header: Text("URL")) {
                TextField(text: $recipe.url, prompt: Text("URL")) {
                    Text(recipe.url)
                }
            }
            Section(header: Text("Category")) {
                Picker("Category", selection: $recipe.categoryName, content: {
                    ForEach(categories, id: \.name) { category in
                        Text(category.name)
                    }
                })
            }
            Section {
                Button(action: {
                    customisePresented = true
                }) {
                    Label("Customise Categories", systemImage: "gearshape")
                }
            }
            .listRowBackground(Color(.systemGray6))
        }
        .navigationTitle("Edit Recipe")
        .navigationBarItems(leading: Button("Cancel") {
            editMode = .inactive
            dismiss()
        }, trailing: saveEditButton)
        .fullScreenCover(isPresented: $customisePresented, onDismiss: {
            self.customisePresented = false
        }, content: {
            NavigationView {
                CustomiseCategoriesView(customisePresented: $customisePresented)
            }
        })
    }
    
    var saveEditButton: some View {
        Button("Save") {
            editMode = .inactive
            Recipe.update(id: recipe.id, name: recipe.name, url: recipe.url, categoryName: recipe.categoryName, in: viewContext)
            dismiss()
        }
        .disabled(recipe.name.isEmpty || recipe.url.isEmpty || recipe.categoryName.isEmpty)
    }
}
