//
//  RecipesView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import SwiftUI
import CoreData

struct RecipesView: View {
    @EnvironmentObject var viewModel: RecipesOrganiserViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Recipe.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var recipes: FetchedResults<Recipe>
    
    @State private var isAddViewPresented = false
    @State var name = ""
    @State var url = ""
    @State var categoryName = ""
    
    @State private var editMode: EditMode = .inactive
    @State private var isEditViewPresented = false
    
    var body: some View {
        if recipes.isEmpty {
            emptyView
        }
        else {
            NavigationView {
                List {
                    ForEach(recipes) { recipe in
                        NavigationLink(destination: RecipeWebView(urlStr: recipe.url)) {
                            RecipeRowView(recipe: recipe)
                                .gesture(editMode == .active ? tap(on: recipe) : nil)
                        }
                    }
                    .onDelete(perform: removeRecipe)
                }
                .navigationTitle("Favourite Recipes")
                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .fullScreenCover(isPresented: $isAddViewPresented) {
                    NavigationView {
                        AddView(name: $name, url: $url, categoryName: $categoryName)
                            .navigationTitle("Add Favourite Recipe")
                            .navigationBarItems(leading: Button("Cancel") {
                                isAddViewPresented = false
                            }, trailing: saveButton)
                    }
                }
                .environment(\.editMode, $editMode)
                .fullScreenCover(isPresented: $isEditViewPresented) {
                    NavigationView {
                        EditView(name: $name, url: $url, categoryName: $categoryName)
                            .navigationTitle("Edit Recipe")
                            .navigationBarItems(leading: Button("Cancel") {
                                isEditViewPresented = false
                                editMode = .inactive
                            }, trailing: saveButton)
                    }
                }
            }
        }
    }
    
    // returns a gesture to occur when RecipeRowView is tapped during edit mode
    func tap(on recipe: Recipe) -> some Gesture {
        TapGesture().onEnded {
            isEditViewPresented = true
            name = recipe.name
            url = recipe.url
            categoryName = recipe.category.name
        }
    }
    
    // Shown when no recipe has been added
    var emptyView: some View {
        ZStack {
            Color.cyan
            
            VStack(alignment: .center, spacing: 20) {
                Text("No Recipe")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text("Let's add your favourite recipes!")
                Button(action: {
                    isAddViewPresented = true
                }) {
                    addRecipeButton
                }
            }
            .fullScreenCover(isPresented: $isAddViewPresented) {
                NavigationView {
                    AddView(name: $name, url: $url, categoryName: $categoryName)
                        .navigationTitle("Add Favourite Recipe")
                        .navigationBarItems(leading: Button("Cancel") {
                            isAddViewPresented = false
                        }, trailing: saveButton)
                }
            }
        }
    }
    
    var addRecipeButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            Text("Add Recipe")
                .foregroundColor(.cyan)
        }
        .frame(width: 120, height: 40)
    }
    
    var addButton: some View {
        Button(action: {
            isAddViewPresented = true
        }) {
            Image(systemName: "plus")
        }
    }
    
    var saveButton: some View {
        Button("Save") {
            Recipe.add(name: name, url: url, categoryName: categoryName, in: viewContext)
            name = ""
            url = ""
            categoryName = ""
            isAddViewPresented = false
        }
        .disabled(name.isEmpty || url.isEmpty || categoryName.isEmpty)
    }
    
    func removeRecipe(at offsets: IndexSet) {
        for index in offsets {
            let recipe = recipes[index]
            viewContext.delete(recipe)
            try? viewContext.save()
        }
    }
}
