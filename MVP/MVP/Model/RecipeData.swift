//
//  RecipeData.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit

struct RecipeData: Codable {
    let q: String
    let from: Int
    let to: Int
    let hits: [Hits]
}

struct Hits: Codable {
    let recipe: Recipe
    let bookmarked: Bool
}

struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
}
