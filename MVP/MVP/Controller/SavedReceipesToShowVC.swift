//
//  SavedReceipesToShowVC.swift
//  MVP
//
//  Created by Sean Murphy on 8/9/21.
//

import UIKit
import CoreData

protocol RecipeToShowDelegate {
    func didUpdateEditableRecipe(recipeToShowVC: SavedReceipesToShowVC)
    func errorUpdatingEditableRecipe(error: Error)
}

class SavedReceipesToShowVC: UIViewController, UITextFieldDelegate, RecipeToShowDelegate {
    func didUpdateEditableRecipe(recipeToShowVC: SavedReceipesToShowVC) {
        <#code#>
    }
    
    
    
    @IBOutlet weak var editableReceipeText: UITextView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedEditableReceipeArray = [SavedReceipes]()
    var recipeTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReceipes()
        navigationController?.title = recipeTitle
    }
    
    func didUpdateEditableRecipe(recipeToShowVC: String, recipe: String) {
        editableReceipeText.text = recipe
        self.recipeTitle = recipeToShowVC
        editableReceipeText.reloadInputViews()
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
//            recipeTitle
//            savedEditableReceipeArray[0].
//            recipeTitle = try context.fetch(Sa)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        editableReceipeText.reloadInputViews()
    }
    
}

