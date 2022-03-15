//
//  SearchView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 15/3/2022.
//

import SwiftUI

struct SearchView: View {
    @FetchRequest(fetchRequest: Recipe.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var recipes: FetchedResults<Recipe>
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @State private var keyword = ""

    var body: some View {
        NavigationView {
            List{
                ForEach(searchResults, id: \.self) { recipe in
                    NavigationLink(destination: RecipeWebView(urlStr: recipe.url)) {
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .searchable(text: $keyword, prompt: "Search recipes")
            .navigationTitle("Search")
            .overlay(keyword.isEmpty ? searchTop: nil)
            .overlay((!keyword.isEmpty && searchResults.isEmpty) ? Text("No Results Found").font(.title3) : nil)
        }
    }
    
    // Search for recipes by the `keyword`.
    // Returns recipes that has a name containing the keyword (case insensitive), and
    // recipes of which category has a name containing the keyword
    var searchResults: [Recipe] {
        if keyword.isEmpty {
            return []
        }
        else {
            var results = [Recipe]()
            
            // recipes with name that contains the keyword
            results += recipes.filter { $0.name.localizedStandardContains(keyword) }

            // categories with name that contains the keyword
            let filteredCategories = categories.filter { $0.name.localizedStandardContains(keyword) }
            filteredCategories.forEach({ category in
                category.recipes.forEach { recipe in
                    // avoid appending a duplicate recipe
                    if !results.contains(recipe) {
                        results.append(recipe)
                    }
                }
            })
            return results
        }
    }
    
    var searchTop: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Search for recipes by any keywords...").font(.title3)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
