//
//  EmptyView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 4/3/2022.
//

import SwiftUI

// Shown when no recipe has been added
struct EmptyView: View {
    @Binding var recipeToAdd: TemporaryRecipeState?
    
    var body: some View {
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
                recipeToAdd = nil
            }, content: { recipe in
                NavigationView {
                    AddView(recipe: recipe)
                }
            })
        }
    }
    
    private var addRecipeButton: some View {
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
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        return EmptyView(recipeToAdd: .constant(TemporaryRecipeState()))
    }
}
