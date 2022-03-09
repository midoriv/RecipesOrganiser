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
    @State private var newCategoryName = ""
    @State private var alertPresented = false
    @State private var messagePresented = false
    
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
                messagePresented = true
                newCategoryName = ""
            }
            .disabled(newCategoryName.isEmpty)
        )
        .alert(isPresented: $alertPresented) {
            Alert(
                title: Text("Can't delete the category"),
                message: Text("There is a recipe under the category."),
                dismissButton: .default(Text("OK"), action: {
                    alertPresented = false
                })
            )
        }
        .overlay(messagePresented ? MessageSheet(messagePresented: $messagePresented) : nil)
    }
    
    func removeCategory(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let toDelete = categories[index]
                
                // if there exists a recipe that falls under this category
                if toDelete.recipes.count == 0 {
                    viewContext.delete(toDelete)
                    try? viewContext.save()
                    print("Category deleted.")
                }
                else {
                    alertPresented = true
                }
            }
        }
    }
}

struct MessageSheet: View {
    @Binding var messagePresented: Bool
    
    var body: some View {
        Color.black
            .navigationBarHidden(true)
            .opacity(0.5)
            .overlay(messageBox)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    messagePresented.toggle()
                }
            }
    }
    
    var messageBox: some View {
        Text("Saved")
            .padding([.top, .bottom], 30)
            .padding([.leading, .trailing], 40)
            .background(.white)
            .cornerRadius(15)
    }
}

struct CustomiseCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CustomiseCategoriesView(customisePresented: .constant(true))
    }
}
