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
    @State private var showingDeletionAlert = false
    @State private var showingAdditionAlert = false
    @State private var showingAddSuccessMessage = false
    
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
                // if the entered category doesn't exit yet
                if Category.withName(newCategoryName, context: viewContext) == nil {
                    Category.add(name: newCategoryName, in: viewContext)
                    showingAddSuccessMessage = true
                }
                else {
                    showingAdditionAlert = true
                }
            }
            .disabled(newCategoryName.isEmpty)
        )
        .alert("Can't delete the category", isPresented: $showingDeletionAlert, actions: {
            Button("OK") {
                showingDeletionAlert = false
            }
        }, message: {
            Text("There is a recipe under the category.")
        })
        .alert("Can't add the category", isPresented: $showingAdditionAlert, actions: {
            Button("OK") {
                showingDeletionAlert = false
            }
        }, message: {
            Text("The category already exists.")
        })
        .overlay(
            showingAddSuccessMessage ?
            MessageSheet(showingAddSuccessMessage: $showingAddSuccessMessage, newCategoryName: $newCategoryName) : nil
        )
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
                    showingDeletionAlert = true
                }
            }
        }
    }
}

struct MessageSheet: View {
    @Binding var showingAddSuccessMessage: Bool
    @Binding var newCategoryName: String
    
    var body: some View {
        Color.gray
            .navigationBarHidden(true)
            .opacity(0.7)
            .overlay(messageBox)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    newCategoryName = ""
                    showingAddSuccessMessage.toggle()
                }
            }
    }
    
    var messageBox: some View {
        Group {
            Text("Added category ") + Text("\(newCategoryName)").bold()
        }
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
