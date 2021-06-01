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
//    var imageArray = [UIImage]()

    static let shared = RecipeManager()
    var delegateManager: ReceipeManagerMultiCastDelegate
    private init() {
        self.delegateManager = ReceipeManagerMultiCastDelegate(delegates: [])
    }

    static var recipeArray = [String]()
    var delegate: RecipeManagerDelegate?

    func fetchRecipe(typeOfFood: String) {

        let urlString = "\(recipeURL)&app_id=\(appID)&app_key=\(appKey)&q=\(typeOfFood)&from=0&to=\(maxNumberOfApiRequests)"
        print(urlString)
        performRequest(urlString: urlString)
    }


    func performRequest(urlString: String) {

        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
//                    self.delegate?.didFailWithError(error: error!)
                    delegateManager.didFailWithError(error: error!)
                    return
                }
                print("here is the data \(data)")
                if let safeData = data {
                    if let recipeModel = parseJSON(safeData) {

//                        self.delegate?.didUpdateRecipe(self, recipeModel: recipeModel)
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
//            recipeList.removeAll()
//            urlList.removeAll()

//            print("This is my recipe list \(recipeList)")
//            print("This is my url list \(urlList)")
            let decodedData = try decoder.decode(RecipeData.self, from: recipeData)

            for i in 0..<maxNumberOfApiRequests {
                imageStringArray.append(contentsOf: [decodedData.hits[i].recipe.image])
//                if let imageString = UIImage(named: decodedData.hits[i].recipe.image) {
//                    imageArray.append(UIImage(imageLiteralResourceName: decodedData.hits[i].recipe.image))
//                } else {
//                    imageArray.append(#imageLiteral(resourceName: ).imageAsset.)
//                }
                recipeList.append(contentsOf: [decodedData.hits[i].recipe.label])
                urlList.append(contentsOf: [decodedData.hits[i].recipe.url])
//                imageArray.append(UIImage(imageLiteralResourceName: decodedData.hits[i].recipe.image))
                
//                imageArray.append(images)
            }
//            for j in 0..<imageStringArray.count {
//                if let imageURL = imageStringArray[j] as? String {
//                    AF.request(imageURL).responseImage { (response) in
//                        print(response)
//                        if let image = response.result.publisher {
//                            
//                        }
////                        imageArray.append(response)
//                    }
//                }
//                AF.request(imageStringArray[j]).responseImage(completionHandler: { response in
//                    debugPrint(response)
//                    print(response.result)
//                    print(response.response)
//                    debugPrint(response.result)
//
//                    if case .success(let image) = response.result {
//                        print("image downloaded: \(image)")
//                    }
//                })
//            }
//            print(urlList)
            var recipe = RecipeModel(recipeLabel: recipeList, urlString: urlList, imageArray: imageStringArray)
//            recipeList.removeAll()
//            urlList.removeAll()
            return recipe
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }

    }
    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() {
////                self?.imageArray.append(UIImage(data: data)!)
////                self.imageArray.
//            }
//        }
//    }
//
//}
//
//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
}

