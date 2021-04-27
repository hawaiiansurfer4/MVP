//
//  RecipeTableViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit

class RecipeTableViewController: UITableViewController, UISearchBarDelegate  {
    
    var recipeManager = RecipeManager()
    var webPageModel = WebPageModel()
    var tableRecipeItems: String = ""
    var recipeArray = [String]()
    var webPageViewController = WebPageViewController()
    static var urlArray = [String]()
    
    enum State {
        case loading
        case sucess
        case error 
    }
    
    @IBOutlet weak var searchBarTextField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTextField.delegate = self
        tableView.delegate = self
        recipeManager.delegate = self
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBarTextField.text!)
        tableView.reloadData()
        searchBarTextField.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            State.loading
            createSpinnerView()
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
        WebPageViewController.webShowRecipeURL = RecipeTableViewController.urlArray[indexPath.row]
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}


//MARK: - RecipeManagerDelegate
    
extension RecipeTableViewController: RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipe: RecipeModel) {
        DispatchQueue.main.async {
            self.recipeArray.removeAll()
            RecipeTableViewController.urlArray.removeAll()
            self.recipeArray.append(contentsOf: recipe.recipeLabel)
            
            RecipeTableViewController.urlArray.append(contentsOf: recipe.urlString)
            
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: - LoadingCircle





