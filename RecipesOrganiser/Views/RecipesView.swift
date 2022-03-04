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
    
    @State var recipeToAdd: TemporaryRecipeState?
    @State var recipeToEdit: TemporaryRecipeState?
    @State private var editMode: EditMode = .inactive
    @State var idToEdit: UUID?
    
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
    }
    
    // returns a gesture to occur when RecipeRowView is tapped during edit mode
    func tap(on recipe: Recipe) -> some Gesture {
        TapGesture(count: 1).onEnded {
            idToEdit = recipe.id
            recipeToEdit = TemporaryRecipeState(name: recipe.name, url: recipe.url, categoryName: recipe.category.name, id: recipe.id!)
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
                addRecipeButton
            }
            .fullScreenCover(item: $recipeToAdd, onDismiss: {
                self.recipeToAdd = nil
            }, content: { recipe in
                NavigationView {
                    AddView(recipe: recipe) 
                }
            })
        }
    }
    
    var addRecipeButton: some View {
        Button(action: {
            recipeToAdd = TemporaryRecipeState()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                Text("Add Recipe")
                    .foregroundColor(.cyan)
            }
            .frame(width: 120, height: 40)
        }
    }
    
    var addButton: some View {
        Button(action: {
            recipeToAdd = TemporaryRecipeState()
        }) {
            Image(systemName: "plus")
        }
    }
    
    func removeRecipe(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let recipe = recipes[index]
                viewContext.delete(recipe)
                try? viewContext.save()
                print("recipe deleted")
            }
        }
    }
}

struct TemporaryRecipeState: Identifiable {
    var name = ""
    var url = ""
    var categoryName = ""
    var id = UUID()
}
