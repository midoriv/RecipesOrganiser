//
//  AddView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI

struct AddView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var recipe: ModifiableRecipe
    @State var customisePresented = false
    
    var body: some View {
        List {
            TextField(text: $recipe.name, prompt: Text("Recipe Name")) {
                Text("Recipe Name")
            }
            TextField(text: $recipe.url, prompt: Text("Recipe URL")) {
                Text("Recipe URL")
            }
            Picker("Category", selection: $recipe.categoryName, content: {
                ForEach(categories, id: \.name) { category in
                    Text(category.name)
                }
            })
            Section {
                Button(action: {
                    customisePresented = true
                }) {
                    Label("Customise Categories", systemImage: "gearshape")
                }
            }
            .listRowBackground(Color(.systemGray6))
        }
        .navigationTitle("Add Favourite Recipe")
        .navigationBarItems(leading: Button("Cancel") {
            dismiss()
        }, trailing: saveButton)
        .fullScreenCover(isPresented: $customisePresented, onDismiss: {
            self.customisePresented = false
        }, content: {
            NavigationView {
                CustomiseCategoriesView(customisePresented: $customisePresented)
            }
        })
    }
    
    var saveButton: some View {
        Button("Save") {
            Recipe.add(name: recipe.name, url: recipe.url, categoryName: recipe.categoryName, in: viewContext)
            dismiss()
        }
        .disabled(recipe.name.isEmpty || recipe.url.isEmpty || recipe.categoryName.isEmpty)
    }
}
