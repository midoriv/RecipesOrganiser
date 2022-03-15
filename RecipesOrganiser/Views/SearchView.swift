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
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List{
                ForEach(searchResults, id: \.self) { recipe in
                    NavigationLink(destination: RecipeWebView(urlStr: recipe.url)) {
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search recipes")
            .navigationTitle("Search")
            .overlay(searchText.isEmpty ? searchTop: nil)
            .overlay((!searchText.isEmpty && searchResults.isEmpty) ? Text("No Results Found").font(.title3) : nil)
        }
    }
    
    var searchResults: [Recipe] {
        if searchText.isEmpty {
            return []
        }
        else {
            var results = [Recipe]()
            results += recipes.filter { $0.name.localizedStandardContains(searchText) }

            let filteredCategories = categories.filter { $0.name.localizedStandardContains(searchText) }
            filteredCategories.forEach({ category in
                category.recipes.forEach { recipe in
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
