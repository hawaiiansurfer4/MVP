//
//  RecipeManager.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit

protocol RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipe: RecipeModel)
    func didFailWithError(error: Error)
}

struct RecipeManager {
    let recipeURL = "https://api.edamam.com/search?"
    let appID = "3214dd26"
    let appKey = "24f428ea7ca46ce12a04eabda6c59909"
    let maxNumberOfApiRequests = 100
    
    static var recipeArray = [String]()
    var delegate: RecipeManagerDelegate?
    
    func fetchRecipe(typeOfFood: String) {
        let urlString = "\(recipeURL)&app_id=\(appID)&app_key=\(appKey)&q=\(typeOfFood)&from=0&to=\(maxNumberOfApiRequests)"
//        print(urlString)
        performRequest(urlString: urlString)
    }
    
        
    func performRequest(urlString: String) {
        
//        adding the spinning circle here
        
        
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let recipe = parseJSON(safeData) {
                        
                        self.delegate?.didUpdateRecipe(self, recipe: recipe)
//                        add loading screen back to normal screen
                        RecipeTableViewController.State.sucess
                    } else {
                        self.delegate?.didUpdateRecipe(self, recipe: RecipeModel(recipeLabel: [], urlString: []))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ recipeData: Data) -> RecipeModel? {
        let decoder = JSONDecoder()
        var recipeList = [String]()
        var urlList = [String]()
        do {
            
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)
            
            if decodedData.hits.count == 0 {
                return nil
            }
            for i in 0..<maxNumberOfApiRequests {
                recipeList.append(contentsOf: [decodedData.hits[i].recipe.label])
            }
            
            for j in 0..<maxNumberOfApiRequests {
                urlList.append(contentsOf: [decodedData.hits[j].recipe.url])
            }
            var recipe = RecipeModel(recipeLabel: recipeList, urlString: urlList)
            
            return recipe
        } catch {
            print(error)
            return nil
        }
        
    }
}



