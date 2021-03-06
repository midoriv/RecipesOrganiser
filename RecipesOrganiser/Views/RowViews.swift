//
//  RecipeRowView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI
import CoreData

struct RecipeRowView: View {
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        if !recipe.name.isEmpty {
            HStack() {
                Text(recipe.name)
                Spacer()
                Text(recipe.category.name)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.cyan)
            }
            .padding()
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack {
            Text(category.name)
            Spacer()
            Text("\(category.recipes.count) recipes")
                .font(.caption)
                .bold()
                .foregroundColor(category.recipes.count == 0 ? .gray : .cyan)
        }
        .padding()
    }
}
