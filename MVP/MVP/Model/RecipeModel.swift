//
//  RecipeModel.swift
//  MVP
//
//  Created by Sean Murphy on 11/3/20.
//

import UIKit

struct RecipeModel {
    var recipeLabel: [String]
    var urlString: [String]
    var imageArray: [String]
//    var errorBool: Bool
    
    mutating func clearData() {
        self.recipeLabel.removeAll()
        self.urlString.removeAll()
        self.imageArray.removeAll()
    }
}
