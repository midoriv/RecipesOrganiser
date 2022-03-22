//
//  CustomiseCategoriesView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 8/3/2022.
//

import SwiftUI

struct CustomiseCategoriesView: View {
    @EnvironmentObject var viewModel: RecipesOrganiserViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Category.fetchRequest(NSPredicate(format: "TRUEPREDICATE"))) var categories: FetchedResults<Category>
    @Binding var customisePresented: Bool
    @State private var newCategoryName = ""
    
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
        .customAlert()
        .overlay(
            viewModel.alertState.addSuccessMessage ? SuccessMessageSheet(newCategoryName: $newCategoryName) : nil
        )
    }
    
    // a button to save / add a new category
    private var saveButton: some View {
        Button("Save") {
            viewModel.addCategory(categoryName: newCategoryName)
        }
        .disabled(newCategoryName.isEmpty)
    }
    
    func removeCategory(at offsets: IndexSet) {
        withAnimation {
            viewModel.removeCategory(offsets)
        }
    }
}

// Apply this modifier to enable a view to show alerts when adding / deleting categories
struct CustomAlert: ViewModifier {
    @EnvironmentObject var viewModel: RecipesOrganiserViewModel
    
    private var showingAlertBinding: Binding<Bool> {
        let alertState = viewModel.alertState
        
        var showingAlert = alertState.addAlert || alertState.deleteAlert || alertState.limitAlert
        return Binding<Bool>(
            get: { showingAlert },
            set: { showingAlert = $0 }
        )
    }
        
    private var alertTitle: String {
        let alertState = viewModel.alertState

        if alertState.addAlert {
            return "Can't add the category"
        }
        
        if alertState.deleteAlert {
            return "Can't delete the category"
        }
        
        if alertState.limitAlert {
            return "Limit Reached"
        }
        
        return ""
    }
    
    private var alertMessage: String {
        let alertState = viewModel.alertState
        
        if alertState.addAlert {
            return "The category already exists."
        }
        
        if alertState.deleteAlert {
            switch(alertState.deletionState) {
            case .failedAsRecipeExists:
                return "There is a recipe under the category."
            case .failedAsDeleteLast:
                return "The last category can't be deleted."
            default:
                return "Error: Deletion failed."
            }
        }
        
        if alertState.limitAlert {
            return "Maximum categories limit of 30 has been reached."
        }
        
        return ""
    }
    
    func body(content: Content) -> some View {
        content
            .alert(alertTitle, isPresented: showingAlertBinding, actions: {
                Button("OK") {
                    viewModel.resetAlertState()
                }
            }, message: {
                Text(alertMessage)
            })
    }
}

extension View {
    func customAlert() -> some View {
        self.modifier(CustomAlert())
    }
}

struct SuccessMessageSheet: View {
    @Binding var newCategoryName: String
    @EnvironmentObject var viewModel: RecipesOrganiserViewModel
    
    var body: some View {
        Color.gray
            .navigationBarHidden(true)
            .opacity(0.7)
            .overlay(messageBox)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    newCategoryName = ""
                    viewModel.turnOffAddSuccessMessage()
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
