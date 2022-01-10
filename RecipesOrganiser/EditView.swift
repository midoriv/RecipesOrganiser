//
//  EditView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 10/1/22.
//

import SwiftUI

struct EditView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Binding var name: String
    @Binding var url: String
    @Binding var categoryName: String
    
    var body: some View {
        List {
            Section(header: Text("Recipe Name")) {
                TextField(text: $name, prompt: Text("Recipe Name")) {
                    Text(name)
                }
            }
            Section(header: Text("URL")) {
                TextField(text: $url, prompt: Text("URL")) {
                    Text(url)
                }
            }
            Section(header: Text("Category")) {
                Picker("Category", selection: $categoryName, content: {
                    ForEach(categories, id: \.name) { category in
                        Text(categoryName)
                    }
                })
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
