//
//  RecipeTableViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit

class RecipeTableViewController: UITableViewController, UISearchBarDelegate  {
    
//    var currentIndexPath = In
    var recipeManager = RecipeManager()
    var webPageModel = WebPageModel()
    var tableRecipeItems: String = ""
    var recipeArray = [String]()
    var urlArray = [String]()

    @IBOutlet weak var searchBarTextField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTextField.delegate = self
        tableView.delegate = self
        recipeManager.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBarTextField.text!)
        tableView.reloadData()
        searchBarTextField.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            tableView.reloadData()
            return true
        } else {
            searchBar.placeholder = "Type Something!"
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let recipe = searchBarTextField.text {
            recipeManager.fetchRecipe(typeOfFood: recipe)
        }
        searchBarTextField.text = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCells", for: indexPath)
        cell.textLabel?.text = recipeArray[indexPath.row] ?? "Nothing searched yet"
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWebView", sender: indexPath.row)
        webPageModel.fetchFinalWebpage(webURL: urlArray[indexPath.row])
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let showWebViewRecipe = segue.destination as? 
//    }
}
//MARK: - RecipeManagerDelegate
    
extension RecipeTableViewController: RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipe: RecipeModel) {
        DispatchQueue.main.async {
            self.recipeArray.append(contentsOf: recipe.recipeLabel)
            self.urlArray.append(contentsOf: recipe.urlString)
            print("the current url array is \(recipe.urlString)")
            
            
            print("The label reads \(recipe.recipeLabel)")
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}
