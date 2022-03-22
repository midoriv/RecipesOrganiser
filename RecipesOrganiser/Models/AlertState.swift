//
//  AlertState.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 22/3/2022.
//

import Foundation

struct AlertState {
    var addAlert = false
    var limitAlert = false
    var deleteAlert = false
    var deletionState = DeletionState.idle
    var addSuccessMessage = false
    
    var alertTitle: String {
        if addAlert {
            return "Can't add the category"
        }
        
        if deleteAlert {
            return "Can't delete the category"
        }
        
        if limitAlert {
            return "Limit Reached"
        }
        
        return ""
    }
    
    var alertMessage: String {
        if addAlert {
            return "The category already exists."
        }
        
        if deleteAlert {
            switch(deletionState) {
            case .failedAsRecipeExists:
                return "There is a recipe under the category."
            case .failedAsDeleteLast:
                return "The last category can't be deleted."
            default:
                return "Error: Deletion failed."
            }
        }
        
        if limitAlert {
            return "Maximum categories limit of 30 has been reached."
        }
        
        return ""
    }
}
