//
//  RecipeRowView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI
import CoreData

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack() {
            Text(recipe.name)
            Text(recipe.url)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
struct RecipeRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let recipe = Recipe(context: context)
        recipe.name = "Test Recipe"
        recipe.url = "https://testrecipe.com"
        
        return RecipeRowView(recipe: recipe)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
