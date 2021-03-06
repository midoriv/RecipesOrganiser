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
    @ObservedObject var errorManager: ErrorManager
    @FetchRequest(fetchRequest: Recipe.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var recipes: FetchedResults<Recipe>
    @State var recipeToAdd: ModifiableRecipe?
    
    var body: some View {
        if errorManager.errorOccurrence {
            Text("Error Occurred.")
        }
        else {
            if recipes.isEmpty {
                EmptyView(recipeToAdd: $recipeToAdd)
            }
            else {
                TabView {
                    MainView(recipeToAdd: $recipeToAdd)
                        .tabItem {
                            Label("All", systemImage: "star.circle")
                        }
                        .tag(1)
                    CategoryListView()
                        .tabItem {
                            Label("Category", systemImage: "square.grid.2x2")
                        }
                        .tag(2)
                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(3)
                }
            }
        }
    }
}

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Recipe.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var recipes: FetchedResults<Recipe>
    @State private var editMode: EditMode = .inactive
    @State var recipeToEdit: ModifiableRecipe?
    @Binding var recipeToAdd: ModifiableRecipe?
    @State var idToEdit: UUID?

    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeWebView(urlStr: recipe.url)) {
                        RecipeRowView(recipe: recipe)
                            .gesture(editMode == .active ? tapToEdit(on: recipe) : nil)
                    }
                }
                .onDelete(perform: removeRecipe)
            }
            .navigationTitle("All Recipes")
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .fullScreenCover(item: $recipeToAdd, onDismiss: {
                self.recipeToAdd = nil
            }, content: { recipe in
                NavigationView {
                    AddView(recipe: recipe)
                }
            })
            .fullScreenCover(item: $recipeToEdit, onDismiss: {
                self.recipeToEdit = nil
            }, content: { recipe in
                NavigationView {
                    EditView(editMode: $editMode, recipe: recipe)
                }
            })
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // returns a gesture to occur when RecipeRowView is tapped during edit mode
    private func tapToEdit(on recipe: Recipe) -> some Gesture {
        TapGesture(count: 1).onEnded {
            idToEdit = recipe.id
            recipeToEdit = ModifiableRecipe(
                name: recipe.name,
                url: recipe.url,
                categoryName: recipe.category.name,
                id: recipe.id!
            )
        }
    }
    
    private var addButton: some View {
        Button(action: {
            recipeToAdd = ModifiableRecipe()
        }) {
            Image(systemName: "plus")
        }
    }
    
    private func removeRecipe(at offsets: IndexSet) {
        withAnimation {
            Recipe.delete(at: offsets, in: viewContext)
        }
    }
}
