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
    @State private var showingAdditionAlert = false
    @State private var showingLimitAlert = false
    @State private var showingAddSuccessMessage = false
    @State private var deletionState = DeletionState.success
    @State private var showingDeletionAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Add New Category")) {
                TextField(text: $newCategoryName, prompt: Text("Category Name")) {
                    Text(newCategoryName)
                }
            }
            Section(header: Text("Your Categories")) {
                ForEach(categories, id: \.name) { category in
                    CategoryRowView(category: category)
                }
                .onDelete(perform: removeCategory)
            }
        }
        .navigationBarTitle("Customise Categories")
        .navigationBarItems(
            leading: Button("Cancel") {
                customisePresented = false
            },
            trailing: saveButton
        )
        .alert("Can't delete the category", isPresented: $showingDeletionAlert, actions: {
            Button("OK") {
                showingDeletionAlert = false
            }
        }, message: {
            switch(deletionState) {
            case .failedAsRecipeExists:
                Text("There is a recipe under the category.")
            case .failedAsDeleteLast:
                Text("The last category can't be deleted.")
            default:
                Text("Error: Deletion failed.")
            }
        })
        .alert("Can't add the category", isPresented: $showingAdditionAlert, actions: {
            Button("OK") {
                showingDeletionAlert = false
            }
        }, message: {
            Text("The category already exists.")
        })
        .alert("Limit Reached", isPresented: $showingLimitAlert, actions: {
            Button("OK") {
                showingLimitAlert = false
            }
        }, message: {
            Text("Maximum categories limit of 30 has been reached.")
        })
        .overlay(
            showingAddSuccessMessage ?
            SuccessMessageSheet(showingAddSuccessMessage: $showingAddSuccessMessage, newCategoryName: $newCategoryName) : nil
        )
    }
    
    // a button to save / add a new category
    private var saveButton: some View {
        Button("Save") {
            // alert case 1: limit reached
            if categories.count >= 30 {
                showingLimitAlert = true
            }
            // alert case 2: the category already exits
            else if Category.withName(newCategoryName, context: viewContext) != nil {
                showingAdditionAlert = true
            }
            else {
                Category.add(name: newCategoryName, in: viewContext)
                showingAddSuccessMessage = true
            }
            
        }
        .disabled(newCategoryName.isEmpty)
    }
    
    func removeCategory(at offsets: IndexSet) {
        withAnimation {
            // show alert if deletion failed
            deletionState = Category.delete(at: offsets, in: viewContext)
            switch(deletionState) {
            case .failedAsRecipeExists, .failedAsDeleteLast, .failedAsEmpty:
                showingDeletionAlert = true
            default:
                showingDeletionAlert = false
            }
        }
    }
}

struct SuccessMessageSheet: View {
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
