//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

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
        print("Here is the location: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        loadItems()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let recipe = historySearchBar.text {
            RecipeManager.shared.fetchRecipe(typeOfFood: recipe)
            var capcity = historyArray.count {
                didSet {
                    if capcity > 8 {
    //                    updatingCapcity(indexPath)
    //                    context.delete(historyArray.remove(at: 0))
                        context.delete(historyArray.removeFirst())
                        historyArray.removeFirst()
//                        historyTable.reloadData()
                        saveItems()
                        loadItems()
                    }
                }
            }
//            context.delete(historyArray.removeFirst())
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
//        searchHistoryModel.push(latestSearch)
        self.saveItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchHistoryModel.searchPopulation().count
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historySearchBar.text = historyArray.map{$0}.reversed()[indexPath.row].text
        context.delete(historyArray.map{$0}.reversed()[indexPath.row])
        saveItems()
        loadItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print(capcity)
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
//        searchCell.textLabel?.text = searchHistoryModel.searchPopulation()[indexPath.row] ?? "No search History"
        updatingCapcity(indexPath)
        let history = historyArray.map{$0}.reversed()[indexPath.row]
//        context.delete(indexPath.row)
        searchCell.textLabel?.text = history.text
        searchCell.textLabel?.numberOfLines = 0
        searchCell.accessoryType = .none
        return searchCell
    }
    
    func updatingCapcity(_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            var idxPath = indexPath
            
        }
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        historyTable.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<SearchHistoryData> = SearchHistoryData.fetchRequest(), predicate: NSPredicate? = nil) {
        
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
