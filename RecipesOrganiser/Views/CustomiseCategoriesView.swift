//
//  CustomiseCategoriesView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 8/3/2022.
//

import SwiftUI

struct CustomiseCategoriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Binding var customisePresented: Bool
    @State var newCategoryName = ""
    
    var body: some View {
        List {
            Section(header: Text("Add New Category")) {
                TextField(text: $newCategoryName, prompt: Text("Category Name")) {
                    Text(newCategoryName)
                }
            }
            Section(header: Text("Your Categories")) {
                ForEach(categories, id: \.name) { category in
                    Text(category.name)
                }
                .onDelete(perform: removeCategory)
            }
        }
        .navigationBarTitle("Categories")
        .navigationBarItems(
            leading: Button("Cancel") {
                customisePresented = false
            },
            trailing: Button("Save") {
                Category.add(name: newCategoryName, in: viewContext)
                customisePresented = false
            }
            .disabled(newCategoryName.isEmpty)
        )
    }
    
    func removeCategory(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let toDelete = categories[index]
                viewContext.delete(toDelete)
                try? viewContext.save()
                print("Category deleted.")
            }
        }
    }
}

struct CustomiseCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CustomiseCategoriesView(customisePresented: .constant(true))
    }
}
