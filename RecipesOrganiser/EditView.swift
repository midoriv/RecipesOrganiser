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
    @State var recipe: Recipe
    
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
                Picker("Category", selection: $recipe.category.name, content: {
                    ForEach(categories, id: \.name) { category in
                        Text(recipe.category.name)
                    }
                })
            }
        }
        .navigationTitle("Edit Recipe")
        .navigationBarItems(leading: Button("Cancel") {
            editMode = .inactive
            dismiss()
        }, trailing: saveEditButton)
    }
    
    var saveEditButton: some View {
        Button("Save") {
            editMode = .inactive
            
            Recipe.update(id: recipe.id!, name: recipe.name, url: recipe.url, categoryName: recipe.category.name, in: viewContext)
            
            dismiss()
        }
        .disabled(recipe.name.isEmpty || recipe.url.isEmpty || recipe.category.name.isEmpty)
    }
}
