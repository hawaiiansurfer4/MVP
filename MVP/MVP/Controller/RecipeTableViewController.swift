//
//  RecipeTableViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/2/20.
//

import UIKit
import SwiftUI
import Alamofire
import AlamofireImage

class RecipeTableViewController: UITableViewController, UISearchBarDelegate {

    var tableRecipeItems: String = ""
    var recipeArray = [String]()
    var webPageViewController = WebPageViewController()
    static var urlArray = [String]()
    var imageStringArray = [String]()
    var kid = SpinnerViewController()
    @State private var searchButtonPressed: Bool = false
    var errorIsSet = Bool() {
        didSet {
            errorMessages(errorIsSet)
            status = .error
        }
    }


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
        tableView.register(UINib(nibName: "RenderingCellTableViewCell", bundle: nil), forCellReuseIdentifier: "RenderingCell")
        tableView.delegate = self
        self.tableView.reloadData()
    }


    @IBAction func searcButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearchHistory", sender: sender)
        status = .loading
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchHistoryVC = segue.destination as? SearchHistoryViewController else { return }
    }


    @IBAction func unwindToRecipeTableVC(segue: UIStoryboardSegue) {
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.showsVerticalScrollIndicator = true
        return recipeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RenderingCell", for: indexPath) as! RenderingCellTableViewCell
        cell.label.text = recipeArray[indexPath.row] ?? "Nothing searched yet"
        if let imageURL = imageStringArray[indexPath.row] as? String {
            AF.request(imageURL).responseImage { (response) in
                if let image = try? response.result.get() {
                    DispatchQueue.main.async {
                        cell.previewImage.image = image
                    }
                }
            }
        }
        cell.previewImage.isOpaque = false

        cell.label.numberOfLines = 0
        cell.accessoryType = .none
        searchButtonPressed = false
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWebView", sender: indexPath.row)
        WebPageViewController.webShowRecipeURL = RecipeTableViewController.urlArray[indexPath.row]
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
        DispatchQueue.main.async {
            self.recipeArray.removeAll()
            RecipeTableViewController.urlArray.removeAll()
            self.imageStringArray.removeAll()
            if recipeModel.recipeLabel.isEmpty || recipeModel.recipeLabel.count < 100 {
                self.updateError(true)
            }
            self.recipeArray.append(contentsOf: recipeModel.recipeLabel)
            RecipeTableViewController.urlArray.append(contentsOf: recipeModel.urlString)
            self.imageStringArray.append(contentsOf: recipeModel.imageArray)
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
        DispatchQueue.main.async {
            self.kid = SpinnerViewController()
            self.addChild(self.kid)
            self.kid.view.frame = self.view.frame
            self.view.addSubview(self.kid.view)
            self.kid.didMove(toParent: self)
        }
    }

    func removeSpinnerView() {

        DispatchQueue.main.asyncAfter(deadline: .now()) {
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
            tableView.isUserInteractionEnabled = false
        case .sucess:
            removeSpinnerView()
            tableView.isUserInteractionEnabled = true
        case .error:
            removeSpinnerView()
            errorMessages(errorIsSet)
        }
    }
}

//MARK: - Error Alert

extension RecipeTableViewController: ErrorUpdate {

    func updateError(_ errorBool: Bool) {
        self.errorIsSet = errorBool
        status = .error
    }

    func errorMessages(_ errorBoolean: Bool) {

        var errorString = ""

        switch errorBoolean {
        case true:
            errorString = "Oops, Something went wrong; Please check your spelling and try again!"
        default:
            errorString = "Unknown Error: Please Check your connection and try again!"
        }

        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            

            let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
                self.status = .sucess
            }


            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }



    }



}

