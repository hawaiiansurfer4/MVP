//
//  SavedReceipesToShowVC.swift
//  MVP
//
//  Created by Sean Murphy on 8/9/21.
//

import UIKit
import CoreData

protocol RecipeToShowDelegate {
    func didUpdateEditableRecipe(recipeToShowVC: SavedReceipesToShowVC, rowNumber: Int)
    func errorUpdatingEditableRecipe(error: Error)
}

class SavedReceipesToShowVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var recipeTitleLabel: UITextField!
    @IBOutlet weak var recipeNavBar: UINavigationItem!
    @IBOutlet weak var editableReceipeText: UITextView!
    var scannerVC = ScannerViewController()
    var selectedRecipe: SavedReceipes? = nil
    var recipeRowNumberToShow: Int?
    var savedRecipes = [SavedReceipes]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")

    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedRecipe != nil) {
            recipeTitleLabel.text = selectedRecipe?.receipeName
            editableReceipeText.text = selectedRecipe?.receipe
        }
//        editableReceipeText.isUserInteractionEnabled = false
        editableReceipeText.isScrollEnabled = true
        recipeTitleLabel.isUserInteractionEnabled = false
        recipeTitleLabel.borderStyle = .none
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            savedRecipes.removeAll()
            for result in results {
                let newRecipe = result as! SavedReceipes
                if(newRecipe == selectedRecipe) {
                    newRecipe.receipeName = recipeTitleLabel.text
                    newRecipe.receipe = editableReceipeText.text
                    try context.save()
                    savedRecipes.append(newRecipe)
                } else {
                    savedRecipes.append(newRecipe)
                }
            }
            savedReceipeList.removeAll()
            savedReceipeList = savedRecipes
            navigationController?.popViewController(animated: true)
        } catch {
            print("Fetch failed")
        }
        recipeTitleLabel.isUserInteractionEnabled = false
        editableReceipeText.isUserInteractionEnabled = false

    }
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        recipeTitleLabel.isUserInteractionEnabled = true
        editableReceipeText.isUserInteractionEnabled = true
        recipeTitleLabel.borderStyle = .bezel
    }

    func errorUpdatingEditableRecipe(error: Error) {
        print("Error updating Editable Recipe \(error)")
    }



//MARK: - UITextField


    func textFieldDidBeginEditing(_ textField: UITextField) {
        recipeTitleLabel.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }


//MARK: - UITextView

    func textViewDidBeginEditing(_ textView: UITextView) {
        editableReceipeText.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        editableReceipeText.resignFirstResponder()
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }


}

