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
}
