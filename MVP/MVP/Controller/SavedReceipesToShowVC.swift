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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedEditableReceipeArray = [SavedReceipes]()
    var recipeTitle: String = "Name This Recipe"
    var recipeRowNumberToShow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableReceipeText.delegate = self
        recipeTitleLabel.isUserInteractionEnabled = true
        loadReceipes()
        editableReceipeText.text = savedEditableReceipeArray[recipeRowNumberToShow].receipe
        recipeTitleLabel.text = savedEditableReceipeArray[recipeRowNumberToShow].receipeName ?? "Name this recipe"
//        navigationController?.delegate = self
//        recipeNavBar.title = recipeTitle
//        recipeTitleLabel.text = recipeTitle
//        editableReceipeText.text = "Testing 1.2.3"
//        recipeNavBar.titleView?.isUserInteractionEnabled = true
    }
    
    func updateUI(label: String, textViewContent: String) {
        editableReceipeText.text = textViewContent
        recipeTitleLabel.text = label
    }
    
    func recipeDetailsToShow(recipeBody: String, recipeTitle: String) {
        DispatchQueue.main.async {
            self.editableReceipeText.text = recipeTitle
            self.recipeTitle = recipeBody
            self.updateUI(label: recipeTitle, textViewContent: recipeBody)
//            self.recipeNavBar.title = recipeTitle
            self.recipeTitleLabel.text = recipeTitle
            print("Here is the recipeDetailsToShow \(recipeBody), \(recipeTitle)")
            self.editableReceipeText.reloadInputViews()
            self.navigationController?.reloadInputViews()
        }
        
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
        
        do {
            savedEditableReceipeArray = try context.fetch(SavedReceipes.fetchRequest())
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        editableReceipeText.text = savedEditableReceipeArray[recipeRowNumberToShow].receipe
        recipeTitleLabel.text = savedEditableReceipeArray[recipeRowNumberToShow].receipeName ?? "Name this recipe"
        editableReceipeText.reloadInputViews()
    }
    
}

