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
    var searchHistoryModel = SearchHistoryModel()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchHistoryVC = segue.destination as? SearchHistoryViewController else { return }
        searchHistoryVC.searchHistoryModel = searchHistoryModel
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
        tableView.showsVerticalScrollIndicator = true
        return recipeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCells", for: indexPath)
        cell.textLabel?.text = recipeArray[indexPath.row] ?? "Nothing searched yet"
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .none
//        scrollToTop()
        searchButtonPressed = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWebView", sender: indexPath.row)
        WebPageViewController.webShowRecipeURL = RecipeTableViewController.urlArray[indexPath.row]
//        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: true)
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
//            self.scrollToTop()
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
//            self.scrollToTop()
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
//            scrollToTop()
//            tableView.scrollToRow(at: <#T##IndexPath#>, at: <#T##UITableView.ScrollPosition#>, animated: <#T##Bool#>)
//            tableView.scrollRectToVisible(CGRect(x: 1, y: 1, width: 0, height: 0), animated: true)
//            tableView.touchesCancelled(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
            
            tableView.isUserInteractionEnabled = false
            print("loading state")
        case .sucess:
            removeSpinnerView()
            tableView.isUserInteractionEnabled = true
            print("success")
        case .error:
            removeSpinnerView()
            print("Error with the switch statement for your enum in State Management")
        }
    }
}

