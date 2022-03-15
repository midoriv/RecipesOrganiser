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

struct ByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
