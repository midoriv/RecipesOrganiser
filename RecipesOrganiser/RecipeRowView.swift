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
        if (!recipe.name.isEmpty) {
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

struct RecipeRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let recipe = Recipe(context: context)
        let category = Category(context: context)
        category.name = "Pasta"
        
        recipe.name = "Test Recipe"
        recipe.category = category
        
        return RecipeRowView(recipe: recipe)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
