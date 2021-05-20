//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    var testArray = ["test","runing","now","go","Search","up","to","now"]
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searhHistoryNavBar: UINavigationBar!
    @IBOutlet weak var searchBarSHVC: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSHVC.becomeFirstResponder()
        historyTable.delegate = self
        searchBarSHVC.delegate = self
        historyTable.dataSource = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "unwindToRecipeTableVC", sender: searchBar)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarSHVC.text = testArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
        cell.textLabel?.text = testArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .none
        return cell
    }
    
}
