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
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var savedEditableReceipeArray = [SavedReceipes]()
    var selectedRecipe: SavedReceipes? = nil
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
    var labelLongPressEnabled = false
    var editableLongPressEnabled = false
    var uniqueID: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedRecipe != nil) {
            recipeTitleLabel.text = selectedRecipe?.receipeName
            editableReceipeText.text = selectedRecipe?.receipe
        }
//        editableReceipeText.delegate = self
//        recipeTitleLabel.delegate = self
        recipeTitleLabel.isUserInteractionEnabled = false
        editableReceipeText.isUserInteractionEnabled = false
//        recipeTitleLabel.snapshotView(afterScreenUpdates: false)
//        editableReceipeText.snapshotView(afterScreenUpdates: false)
//        loadReceipes()
//        editableReceipeText.text = showThisRecipe
//        recipeTitleLabel.text = recipeTitle
    }
    
//    func updateUI(label: String, textViewContent: String) {
//        editableReceipeText.text = textViewContent
//        recipeTitleLabel.text = label
//    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedRecipe == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "SavedReceipes", in: context)
            let newRecipe = SavedReceipes(entity: entity!, insertInto: context)
            newRecipe.receipe = editableReceipeText.text
            newRecipe.receipeName = recipeTitleLabel.text
//            newRecipe.uniqueID = //Figure out where the count is coming from
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print("context save error")
            }
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let recipe = result as! SavedReceipes
                    if(recipe == selectedRecipe) {
                        recipe.receipeName = recipeTitleLabel.text
                        recipe.receipe = editableReceipeText.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
        recipeTitleLabel.isUserInteractionEnabled = false
        editableReceipeText.isUserInteractionEnabled = false
        
    }
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        recipeTitleLabel.isUserInteractionEnabled = true
        editableReceipeText.isUserInteractionEnabled = true
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
//        recipeTitleLabel.resignFirstResponder()
//        saveReceipes()
        return true
    }


    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text {
            print("Line 116 ################### \(text)")
            if let recipeBody = editableReceipeText.text {
                print("Line 118 \(showThisRecipe)")
//                updateUI(label: text, textViewContent: recipeBody)
//                updateEditedRecipe(text, recipeBody)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        saveReceipes()
//        editableReceipeText.resignFirstResponder()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
//    func updateEditedRecipe(_ newName: String, _ newBody: String) {
//        let titleUpdate = SavedReceipes(context: context)
//        titleUpdate.receipeName = newName
//        titleUpdate.receipe = newBody
////        titleUpdate.uniqueID
//        saveReceipes()
//    }
    
    
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

