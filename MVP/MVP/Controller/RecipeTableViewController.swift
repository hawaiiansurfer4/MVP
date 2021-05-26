//
//  RecipeTableViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit
import SwiftUI

class RecipeTableViewController: UITableViewController, UISearchBarDelegate  {

    var webPageModel = WebPageModel()
    var tableRecipeItems: String = ""
    var recipeArray = [String]()
    var webPageViewController = WebPageViewController()
    static var urlArray = [String]()
    var kid = SpinnerViewController()
    @State private var searchButtonPressed: Bool = false
    
    enum Status {
        case none
        case loading
        case sucess
        case error
    }
    
    var status: Status = .none {
        didSet { UpdateUI() }
    }
    
    
    @IBOutlet weak var searchBarTextField: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RecipeManager.shared.delegateManager.multicast.add(self)
        
//        searchBarTextField.delegate = self
        tableView.delegate = self
//        recipeManager.delegate = self
//        self.loadView()
        self.tableView.reloadData()
//        reloadInputViews()
    }
    
    
    @IBAction func searcButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearchHistory", sender: sender)
//        tableView.reloadData()
        status = .loading
    }
    
    @IBAction func unwindToRecipeTableVC(segue: UIStoryboardSegue) {
//        tableView.reloadData()
//        status = .loading
//        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBarTextField.text!)
        
        tableView.reloadData()
        searchBarTextField.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            searchButtonPressed = true
            status = .loading
            tableView.reloadData()
            return true
        } else {
            searchBar.placeholder = "Type Something!"
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let recipe = searchBarTextField.text {
            RecipeManager.shared.fetchRecipe(typeOfFood: recipe)
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
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipeModel: RecipeModel) {
        print("Recipte Table VC noticed the update")
        DispatchQueue.main.async {
            self.recipeArray.removeAll()
            RecipeTableViewController.urlArray.removeAll()
            self.recipeArray.append(contentsOf: recipeModel.recipeLabel)

            RecipeTableViewController.urlArray.append(contentsOf: recipeModel.urlString)
            self.tableView.reloadData()
            self.status = .sucess
        }
    }
    
    func didFailWithError(error: Error) {
        print("Recipte Table VC noticed the error")
        print(error)
        
        status = .error
    }

}

//MARK: - spinner

extension RecipeTableViewController {
    func createSpinnerView() {
        DispatchQueue.main.async{
            self.kid = SpinnerViewController()
            // add the spinner view controller
            self.addChild(self.kid)
            self.kid.view.frame = self.view.frame
            self.view.addSubview(self.kid.view)
            self.kid.didMove(toParent: self)
        }
    }
    
    func removeSpinnerView() {

        // simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // then remove the spinner view controller
            self.kid.willMove(toParent: nil)
            self.kid.view.removeFromSuperview()
            self.kid.removeFromParent()
            self.kid = SpinnerViewController()
        }
    }
}


//MARK: - State Management

extension RecipeTableViewController {
    
    func UpdateUI() {
        
        switch status {
        case .none:
            print("reset the state")
        case .loading:
            createSpinnerView()
            
            print("loading state")
        case .sucess:
            removeSpinnerView()
            print("success")
        case .error:
            removeSpinnerView()
            print("Error with the switch statement for your enum in State Management")
        }
    }
}

