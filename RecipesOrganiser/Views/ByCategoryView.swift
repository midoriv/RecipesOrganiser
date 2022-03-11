//
//  ByCategoryView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 11/3/2022.
//

import SwiftUI

struct ByCategoryView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.name) { category in
                    NavigationLink(destination: RecipesByCategoryView(category: category)) {
                        Text(category.name)
                    }
                }
            }
            .navigationTitle("Categories")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ByCategoryView()
    }
}
