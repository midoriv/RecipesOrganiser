//
//  AddView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI

struct AddView: View {
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Binding var name: String
    @Binding var url: String
    @Binding var categoryName: String
    
    var body: some View {
        List {
            TextField(text: $name, prompt: Text("Recipe Name")) {
                Text("Recipe Name")
            }
            TextField(text: $url, prompt: Text("Recipe URL")) {
                Text("Recipe URL")
            }
            Picker("Category", selection: $categoryName, content: {
                ForEach(categories, id: \.name) { category in
                    Text(category.name)
                }
            })
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddView()
//    }
//}
