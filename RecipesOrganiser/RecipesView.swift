//
//  RecipesView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import SwiftUI
import CoreData

struct RecipesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(fetchRequest: Recipe.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var recipes: FetchedResults<Recipe>
    
    @State private var isAddViewPresented = false
    @State var title = ""
    @State var url = ""
    
    var body: some View {
        if recipes.isEmpty {
            emptyView
        }
        else {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeWebView(url: recipe.url)) {
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Favourite Recipes")
            .navigationBarItems(leading: editButton, trailing: addButton)
            .fullScreenCover(isPresented: $isAddViewPresented) {
                NavigationView {
                    AddView(title: $title, url: $url)
                        .navigationTitle("Add Favourite Recipe")
                        .navigationBarItems(leading: Button("Cancel") {
                            isAddViewPresented = false
                        })
                }
            }
        }
        
    }
    
    var emptyView: some View {
        ZStack {
            Color.cyan
            
            VStack(alignment: .center, spacing: 20) {
                Text("No Recipe")
                Text("Let's add your favourite recipes!")
                Button(action: {
                    isAddViewPresented = true
                }) {
                    addRecipeButton
                }
            }
            .fullScreenCover(isPresented: $isAddViewPresented) {
                NavigationView {
                    AddView(title: $title, url: $url)
                        .navigationTitle("Add Favourite Recipe")
                        .navigationBarItems(leading: Button("Cancel") {
                            isAddViewPresented = false
                        })
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
    
//    var saveButton: some View {
//        Button("Save") {
//            viewModel.add(title: title, url: url)
//            title = ""
//            url = ""
//            isAddViewPresented = false
//        }
//        .disabled(title.isEmpty || url.isEmpty)
//    }
    
    var editButton: some View {
        NavigationLink(destination: EditView()) {
            Text("Edit")
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
