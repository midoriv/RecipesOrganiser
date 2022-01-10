//
//  RecipeRowView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack() {
            Text(recipe.name)
            Text(recipe.url)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}
