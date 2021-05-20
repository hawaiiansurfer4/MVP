//
//  SearchHistoryViewController.swift
//  MVP
//
//  Created by Sean Murphy on 5/19/21.
//

import UIKit

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searhHistoryNavBar: UINavigationBar!
    @IBOutlet weak var searchBarSHVC: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.delegate = self
        searchBarSHVC.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "unwindToRecipeTableVC", sender: searchBar)
    }
    
}
