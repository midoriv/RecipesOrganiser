//
//  RecipesByCategoryView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 11/3/2022.
//

import SwiftUI

struct RecipesByCategoryView: View {
    var category: Category
    
    var body: some View {
        Group {
            if category.recipes.isEmpty {
                Text("No recipe under this category.")
            }
            else {
                List {
                    ForEach(Array(category.recipes)) { recipe in
                        NavigationLink(destination: RecipeWebView(urlStr: recipe.url)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
    }
}

struct RecipesByCategoryView_Previews: PreviewProvider {    
    static var previews: some View {
        RecipesByCategoryView(category: Category())
    }
}
