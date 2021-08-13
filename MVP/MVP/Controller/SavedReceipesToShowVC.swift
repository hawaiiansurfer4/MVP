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

class SavedReceipesToShowVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var recipeTitleLabel: UITextField!
    @IBOutlet weak var recipeNavBar: UINavigationItem!
    @IBOutlet weak var editableReceipeText: UITextView!
    var scannerVC = ScannerViewController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedEditableReceipeArray = [SavedReceipes]()
    var recipeTitle: String?
    var recipeRowNumberToShow: Int?
    var showThisRecipe: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableReceipeText.delegate = self
        
        recipeTitleLabel.isUserInteractionEnabled = true
        
        loadReceipes()
        editableReceipeText.text = showThisRecipe
        recipeTitleLabel.text = recipeTitle
    }
    
    func updateUI(label: String, textViewContent: String) {
        editableReceipeText.text = textViewContent
        recipeTitleLabel.text = label
    }
    
    
    func errorUpdatingEditableRecipe(error: Error) {
        print("Error updating Editable Recipe \(error)")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editableReceipeText.becomeFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editableReceipeText.resignFirstResponder()
        saveReceipes()
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveReceipes() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        loadReceipes()
    }
    
    func loadReceipes(with request: NSFetchRequest<SavedReceipes> = SavedReceipes.fetchRequest() , predicate: NSPredicate? = nil) {
        DispatchQueue.main.async {
            do {
                self.savedEditableReceipeArray = try self.context.fetch(SavedReceipes.fetchRequest())
            } catch {
                print("Error fetching data from context \(error)")
            }
            
//            self.editableReceipeText.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow].receipe
//            self.recipeTitleLabel.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow].receipeName ?? "Name this recipe"
            self.editableReceipeText.reloadInputViews()
        }
        
    }
    
}

