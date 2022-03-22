//
//  DeletionState.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 15/3/2022.
//

import Foundation

enum DeletionState {
    case idle
    case success
    case failedAsRecipeExists
    case failedAsDeleteLast
    case failedAsEmpty
}
