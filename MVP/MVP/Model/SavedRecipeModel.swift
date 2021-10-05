//
//  ScannerModel.swift
//  MVP
//
//  Created by Sean Murphy on 9/22/21.
//

import UIKit

struct SavedRecipeModel {
    var recipeName: [String]
    var recipeDescription: [String]
    var imageArray: [String]
    
    mutating func clearData() {
        self.recipeName.removeAll()
        self.recipeDescription.removeAll()
        self.imageArray.removeAll()
    }
}
