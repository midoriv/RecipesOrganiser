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
    @State private var deletionState = DeletionState.idle
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
        .customAlert(add: $showingAdditionAlert, delete: $showingDeletionAlert, deleteState: $deletionState, limit: $showingLimitAlert)
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
            // if deletion failed for any reason
            case .failedAsRecipeExists, .failedAsDeleteLast, .failedAsEmpty:
                showingDeletionAlert = true
            default:
                showingDeletionAlert = false
                deletionState = .idle
            }
        }
    }
}

// Apply this modifier to enable a view to show alerts when adding / deleting categories
struct CustomAlert: ViewModifier {
    @Binding var showingAdditionAlert: Bool
    @Binding var showingDeletionAlert: Bool
    @Binding var deletionState: DeletionState
    @Binding var showingLimitAlert: Bool
    
    private var showingAlertBinding: Binding<Bool> {
        var showingAlert = showingAdditionAlert || showingDeletionAlert || showingLimitAlert
        return Binding<Bool>(
            get: { showingAlert },
            set: { showingAlert = $0 }
        )
    }
        
    private var alertTitle: String {
        if showingAdditionAlert {
            return "Can't add the category"
        }
        
        if showingDeletionAlert {
            return "Can't delete the category"
        }
        
        if showingLimitAlert {
            return "Limit Reached"
        }
        
        return ""
    }
    
    private var alertMessage: String {
        if showingAdditionAlert {
            return "The category already exists."
        }
        
        if showingDeletionAlert {
            switch(deletionState) {
            case .failedAsRecipeExists:
                return "There is a recipe under the category."
            case .failedAsDeleteLast:
                return "The last category can't be deleted."
            default:
                return "Error: Deletion failed."
            }
        }
        
        if showingLimitAlert {
            return "Maximum categories limit of 30 has been reached."
        }
        
        return ""
    }
    
    func body(content: Content) -> some View {
        content
            .alert(alertTitle, isPresented: showingAlertBinding, actions: {
                Button("OK") {
                    showingAdditionAlert = false
                    showingDeletionAlert = false
                    showingLimitAlert = false
                    deletionState = .idle
                }
            }, message: {
                Text(alertMessage)
            })
    }
}

extension View {
    func customAlert(add: Binding<Bool>, delete: Binding<Bool>, deleteState: Binding<DeletionState>, limit: Binding<Bool>) -> some View {
        self.modifier(
            CustomAlert(
                showingAdditionAlert: add,
                showingDeletionAlert: delete,
                deletionState: deleteState,
                showingLimitAlert: limit
            )
        )
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
