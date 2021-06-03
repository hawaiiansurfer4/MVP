//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit
import CoreData

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    var testArray = ["Chicken","Country","Steak","Shrimp","Scallop","Banana","Nutella","Whip Cream"]
    var searchHistoryModel = SearchHistoryModel()
    var historyArray = [SearchHistoryData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
//        loadItems()
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
    }
    
    func updateSearchHistory(_ latestSearch: String) {
        let newSearch = SearchHistoryData(context: context)
        newSearch.text = latestSearch
        searchHistoryModel.push(latestSearch)
        self.saveItems()
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
//        searchCell.textLabel?.text = searchHistoryModel.searchPopulation()[indexPath.row] ?? "No search History"
        let history = historyArray[indexPath.row]
        searchCell.textLabel?.text = history.text
        searchCell.textLabel?.numberOfLines = 0
        searchCell.accessoryType = .none
        return searchCell
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
//        self.tableView.reloadData()
        historyTable.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<SearchHistoryData> = SearchHistoryData.fetchRequest(), predicate: NSPredicate? = nil) {
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }

        
        do {
            historyArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        historyTable.reloadData()
        
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
