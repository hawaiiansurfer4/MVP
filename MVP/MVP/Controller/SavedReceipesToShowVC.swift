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
    var uniqueID: String = ""
    var recipeTitle: String? {
        didSet {
            print("Line 27")
        }
    }
    var recipeRowNumberToShow: Int?
    var showThisRecipe: String? {
        didSet {
            print("Line 34")
        }
    }
    var savedRecipes = [SavedReceipes]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")

    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedRecipe != nil) {
            recipeTitleLabel.text = selectedRecipe?.receipeName
            editableReceipeText.text = selectedRecipe?.receipe
        }
        recipeTitleLabel.isUserInteractionEnabled = false
        editableReceipeText.isUserInteractionEnabled = false
        recipeTitleLabel.borderStyle = .none
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let newRecipe = result as! SavedReceipes
                if(newRecipe == selectedRecipe) {
                    newRecipe.receipeName = recipeTitleLabel.text
                    newRecipe.receipe = editableReceipeText.text
                    try context.save()
                    scannerVC.tableView.reloadData()
                    navigationController?.popViewController(animated: true)
                }
            }
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


    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text {
            print("Line 116 ################### \(text)")
            if let recipeBody = editableReceipeText.text {
                print("Line 118 \(showThisRecipe)")
            }
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }


//MARK: - UITextView

    func textViewDidBeginEditing(_ textView: UITextView) {
        editableReceipeText.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let body = textView.text {
//            updatedEditedRecipeBody(body)
        }
        editableReceipeText.resignFirstResponder()
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        editableReceipeText.resignFirstResponder()
        return true
    }


    func textViewDidChange(_ textView: UITextView) {
//        saveReceipes()
    }



//MARK: - Model Manipulation Methods

//    func saveReceipes() {
//
////        let savedRecipesEntity = NSEntityDescription.entity(forEntityName: "SavedReceipes", in: context)!
////        let updatedValue = NSManagedObject(entity: savedRecipesEntity, insertInto: context)
////        updatedValue.setValue(recipeTitle, forKeyPath: "receipeName")
////        updatedValue.setValue(showThisRecipe, forKey: "receipe")
//
//        do {
//          try context.save()
//        } catch {
//           print("Error saving context \(error)")
//        }
////        loadReceipes()
//    }
//
//    func loadReceipes(with request: NSFetchRequest<NSFetchRequestResult> = SavedReceipes.fetchRequest() , predicate: NSPredicate? = nil) {
//        DispatchQueue.main.async {
//            do {
//                self.savedEditableReceipeArray = try self.context.fetch(NSFetchRequest<SavedReceipes>)
//            } catch {
//                print("Error fetching data from context \(error)")
//            }
//
////            self.editableReceipeText.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow!].receipe
////            self.recipeTitleLabel.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow!].receipeName
//            self.editableReceipeText.reloadInputViews()
//        }
//
//    }

}

