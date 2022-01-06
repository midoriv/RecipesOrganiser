//
//  AddView.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 29/11/21.
//

import SwiftUI

struct AddView: View {
    @Binding var title: String
    @Binding var url: String
    
    var body: some View {
        
        List {
            TextField(text: $title, prompt: Text("Recipe Title")) {
                Text("Recipe Title")
            }
            TextField(text: $url, prompt: Text("Recipe URL")) {
                Text("Recipe URL")
            }
        }
        
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddView()
//    }
//}
