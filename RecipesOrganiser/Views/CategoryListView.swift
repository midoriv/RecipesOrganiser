//
//  CategoryListView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 11/3/2022.
//

import SwiftUI

struct CategoryListView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @State private var showingCustomiseView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.name) { category in
                    NavigationLink(destination: RecipesByCategoryView(category: category)) {
                        CategoryRowView(category: category)
                    }
                }
            }
            .navigationTitle("Category")
            .navigationBarItems(trailing: customiseButton)
            .fullScreenCover(isPresented: $showingCustomiseView, onDismiss: {
                self.showingCustomiseView = false
            }, content: {
                NavigationView {
                    CustomiseCategoriesView(customisePresented: $showingCustomiseView)
                }
            })
        }
    }
    
    private var customiseButton: some View {
        Button(action: {
            showingCustomiseView = true
        }) {
            Image(systemName: "gearshape")
        }
    }
}



struct ByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
