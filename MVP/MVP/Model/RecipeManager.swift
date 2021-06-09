//
//  RecipeManager.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit
import Alamofire
import AlamofireImage

protocol RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipeModel: RecipeModel)
    func didFailWithError(error: Error)
}

protocol ErrorUpdate {
    func updateError(_ errorBool: Bool)
}

class ReceipeManagerMultiCastDelegate: NSObject, RecipeManagerDelegate {

    let multicast = MulticastDelegate<RecipeManagerDelegate>()

    init(delegates: [RecipeManagerDelegate]) {
        super.init()
        delegates.forEach(multicast.add)
    }

    func didUpdateRecipe(_ recipeManager: RecipeManager, recipeModel: RecipeModel) {
        multicast.invoke { $0.didUpdateRecipe(recipeManager, recipeModel: recipeModel) }
    }

    func didFailWithError(error: Error) {
        multicast.invoke { $0.didFailWithError(error: error) }
    }
}

struct RecipeManager {
    let recipeURL = "https://api.edamam.com/search?"
    let appID = "3214dd26"
    let appKey = "24f428ea7ca46ce12a04eabda6c59909"
    let maxNumberOfApiRequests = 100

    static let shared = RecipeManager()
    var delegateManager: ReceipeManagerMultiCastDelegate
    private init() {
        self.delegateManager = ReceipeManagerMultiCastDelegate(delegates: [])
    }

    static var recipeArray = [String]()
    var delegate: RecipeManagerDelegate?
    var errorUpdate: ErrorUpdate?

    func fetchRecipe(typeOfFood: String) {

        let urlString = "\(recipeURL)&app_id=\(appID)&app_key=\(appKey)&q=\(typeOfFood)&from=0&to=\(maxNumberOfApiRequests)"
        performRequest(urlString: urlString)
    }


    func performRequest(urlString: String) {

        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegateManager.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let recipeModel = parseJSON(safeData) {

                        delegateManager.didUpdateRecipe(self, recipeModel: recipeModel)
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
        var imageStringArray = [String]()
        var imageArray = [UIImage]()
        do {
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)
                for i in 0..<maxNumberOfApiRequests {
                    if decodedData.count <= 100 {
                        self.errorUpdate?.updateError(true)
                        return RecipeModel(recipeLabel: [], urlString: [], imageArray: [])
                    }
                    imageStringArray.append(contentsOf: [decodedData.hits[i].recipe.image])
                    recipeList.append(contentsOf: [decodedData.hits[i].recipe.label])
                    urlList.append(contentsOf: [decodedData.hits[i].recipe.url])
                }
            
            var recipe = RecipeModel(recipeLabel: recipeList, urlString: urlList, imageArray: imageStringArray)
            return recipe
        } catch {
            delegateManager.didFailWithError(error: error)
            self.errorUpdate?.updateError(false)
            return nil
        }

    }
    
   
}

