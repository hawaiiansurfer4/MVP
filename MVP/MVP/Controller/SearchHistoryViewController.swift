//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit
import CoreData
//import IQKeyboardManagerSwift

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    var testArray = ["Chicken","Country","Steak","Shrimp","Scallop","Banana","Nutella","Whip Cream"]
    var searchHistoryModel = SearchHistoryModel()
    var historyArray = [SearchHistoryData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var count = 0 {
        didSet {
            if count > CAPACITY {
                context.delete(historyArray.removeFirst())
                saveItems()
            }
        }
    }
    let CAPACITY = 8
    
    
    
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
        historyTable.isScrollEnabled = false
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        loadItems()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            historyTable.contentInset = .zero
        } else {
            historyTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        historyTable.scrollIndicatorInsets = historyTable.contentInset

//        let selectedRange = yourTextView.selectedRange
//        yourTextView.scrollRangeToVisible(selectedRange)
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
//        searchHistoryModel.push(latestSearch)
        self.saveItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchHistoryModel.searchPopulation().count
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historySearchBar.text = historyArray.map{$0}.reversed()[indexPath.row].text
//        context.delete(historyArray.map{$0}.reversed()[indexPath.row])
//        saveItems()
//        loadItems()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
        updatingCapcity(indexPath)
        let history = historyArray.map{$0}.reversed()[indexPath.row]
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
            count = historyArray.count
            print("Here is the count \(count)")
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
