//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    var testArray = ["Chicken","Country","Steak","Shrimp","Scallop","Banana","Nutella","Whip Cream"]
    var searchHistoryModel = SearchHistoryModel()
    
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searhHistoryNavBar: UINavigationBar!
    @IBOutlet weak var historySearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historySearchBar.becomeFirstResponder()
        historyTable.delegate = self
        historySearchBar.delegate = self
        historyTable.dataSource = self
        RecipeManager.shared.delegateManager.multicast.add(self)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let recipe = historySearchBar.text {
            RecipeManager.shared.fetchRecipe(typeOfFood: recipe)
            updateSearchHistory(recipe)
        }
        
        historySearchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if historySearchBar.text != "" {
            performSegue(withIdentifier: "unwindToRecipeTableVC", sender: searchBar)
            
        } else {
            searchBar.placeholder = "Type Something!"
        }
//        let recipeTableVC = RecipeTableViewController()
//        recipeTableVC.status = .loading
//        recipeTableVC.createSpinnerView()
    }
    
    func updateSearchHistory(_ latestSearch: String) {
        searchHistoryModel.push(latestSearch)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryModel.searchPopulation().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historySearchBar.text = searchHistoryModel.searchPopulation()[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
//        cell.textLabel?.text = testArray[indexPath.row] ?? "No Search History yet"
        searchCell.textLabel?.text = searchHistoryModel.searchPopulation()[indexPath.row] ?? "No search History"
//        let tempArray = searchHistoryModel.searchPopulation()
//        cell.textLabel?.text = tempArray[indexPath.row]  ?? "No Search History yet"
        searchCell.textLabel?.numberOfLines = 0
        searchCell.accessoryType = .none
        return searchCell
    }
    
}


extension SearchHistoryViewController: RecipeManagerDelegate {
    func didUpdateRecipe(_ recipeManager: RecipeManager, recipeModel: RecipeModel) {
        print("Search History VC notices the update")
    }
    
    func didFailWithError(error: Error) {
        print("Search History VC notices the error")
    }
}
