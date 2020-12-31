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
//            recipeList.removeAll()
//            urlList.removeAll()
            
//            print("This is my recipe list \(recipeList)")
//            print("This is my url list \(urlList)")
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)
            
            for i in 0..<maxNumberOfApiRequests {
                recipeList.append(contentsOf: [decodedData.hits[i].recipe.label])
            }
            
            for j in 0..<maxNumberOfApiRequests {
                urlList.append(contentsOf: [decodedData.hits[j].recipe.url])
            }
//            print(urlList)
            var recipe = RecipeModel(recipeLabel: recipeList, urlString: urlList)
//            recipeList.removeAll()
//            urlList.removeAll()
            return recipe
        } catch {
            print(error)
            return nil
        }
        
    }
}


