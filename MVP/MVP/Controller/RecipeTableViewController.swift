//
//  RecipeTableViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit
import SwiftUI

class RecipeTableViewController: UITableViewController, UISearchBarDelegate  {
    
    var recipeManager = RecipeManager()
    var webPageModel = WebPageModel()
    var tableRecipeItems: String = ""
    var recipeArray = [String]()
    var webPageViewController = WebPageViewController()
    static var urlArray = [String]()
//    let child = SpinnerViewController()
    var kid = SpinnerViewController()
    @State private var searchButtonPressed: Bool = false
    
    enum Status {
        case none
        case loading
        case sucess
//        case error
        
    }
    
    var status: Status = .none {
        didSet {
            UpdateUI()
        }
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
//        stateManagement(State.loading)
        
        tableView.reloadData()
        searchBarTextField.endEditing(true)
//        stateManagement(State.loading)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        stateManagement(State.loading)
        if searchBar.text != "" {
            searchButtonPressed = true
            status = .loading
//            State.loading
//            createSpinnerView()
//            stateManagement(State.loading)
            tableView.reloadData()
            return true
        } else {
            searchBar.placeholder = "Type Something!"
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let recipe = searchBarTextField.text {
//            stateManagement(State.loading)
            recipeManager.fetchRecipe(typeOfFood: recipe)
        }
        
//        stateManagement(State.loading) move to global
        searchBarTextField.text = ""
//        stateManagement(State.loading)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCells", for: indexPath)
//        State.sucess
        
//        removeSpinnerView()
        cell.textLabel?.text = recipeArray[indexPath.row] ?? "Nothing searched yet"
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .none
//        stateManagement(State.none)
//        stateManagement(State.sucess)
        searchButtonPressed = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWebView", sender: indexPath.row)
        WebPageViewController.webShowRecipeURL = RecipeTableViewController.urlArray[indexPath.row]
//        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: - RecipeManagerDelegate
    
extension RecipeTableViewController: RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipe: RecipeModel) {
        DispatchQueue.main.async {
//            self.stateManagement(State.loading)
            self.recipeArray.removeAll()
            RecipeTableViewController.urlArray.removeAll()
            self.recipeArray.append(contentsOf: recipe.recipeLabel)
            
            RecipeTableViewController.urlArray.append(contentsOf: recipe.urlString)
//            self.stateManagement(State.sucess)
            self.tableView.reloadData()
            self.status = .sucess
//            self.stateManagement(State.sucess)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: - spinner

extension RecipeTableViewController {
    func createSpinnerView() {
        kid = SpinnerViewController()
        // add the spinner view controller
        addChild(kid)
        kid.view.frame = view.frame
        view.addSubview(kid.view)
        kid.didMove(toParent: self)
    }
    
    func removeSpinnerView() {

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // then remove the spinner view controller
            self.kid.willMove(toParent: nil)
            self.kid.view.removeFromSuperview()
            self.kid.removeFromParent()
            self.kid = SpinnerViewController()
//            self.kid.delete(Any?)
//            self.spinner(State.none)
        }
    }
}


//MARK: - State Management

extension RecipeTableViewController {
    
    func UpdateUI() {
        
        switch status {
        case .none:
            print("reset the state")
//            removeSpinnerView()
        case .loading:
            createSpinnerView()
            print("loading state")
        case .sucess:
            removeSpinnerView()
            print("success")
//            State.none
//        case .error:
//            print("Error with the switch statement for your enum in State Management")
        }
    }
}



