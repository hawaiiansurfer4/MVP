//
//  RecipeManager.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipe: RecipeModel)
    func didFailWithError(error: Error)
}

struct RecipeManager {
    let recipeURL = "https://api.edamam.com/search?"
    let appID = "3214dd26"
    let appKey = "24f428ea7ca46ce12a04eabda6c59909"
    
    var delegate: RecipeManagerDelegate?
    
//    internal var recipeSearchList: [String]
    
    func fetchRecipe(typeOfFood: String) {
        let urlString = "\(recipeURL)&app_id=\(appID)&app_key=\(appKey)&q=\(typeOfFood)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let recipe = parseJSON(safeData) {
                        self.decodeData(safeData)
                        self.delegate?.didUpdateRecipe(self, recipe: recipe)
                    }
                }
            }
            task.resume()
        }
    }
    
    func decodeData(_ recipeData: Data) {
        do {
            let json = try JSON(data: recipeData)
            let foodName = json["hits"].stringValue
            let swiftyDecode = JSON(recipeData)
            
            print("the swiftyDecode is \(swiftyDecode)")
            print("The food name is \(foodName)")
//            print("the decoded data using swiftyJSON is \(json)")
        } catch {
            fatalError("Decoding data using SwiftyJSON failed")
        }
        
    }
    
    func parseJSON(_ recipeData: Data) -> RecipeModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)
            
//            DispatchQueue.main.async {
//                for i in 0...99 {
//                    print(decodedData.hits[0].recipe.ingredientLines)
                    let recipeList = decodedData.hits[0].recipe.label
                    let recipe = RecipeModel(recipeLabel: recipeList)
//                    print(recipe.recipeLabel)
                    return recipe
//                }
//            }
        } catch {
            print(error)
            return nil
        }
        
    }
}
