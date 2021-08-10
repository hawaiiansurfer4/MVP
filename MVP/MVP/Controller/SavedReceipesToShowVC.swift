//
//  SavedReceipesToShowVC.swift
//  MVP
//
//  Created by Sean Murphy on 8/9/21.
//

import UIKit
import CoreData

class SavedReceipesToShowVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var editableReceipeText: UITextView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedEditableReceipeArray = [SavedReceipes]()
    var recipeTitle = [SavedReceipes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReceipes()
//        navigationController?.title =
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
    
    func loadReceipes(with request: NSFetchRequest<SavedReceipes> = SavedReceipes.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            savedEditableReceipeArray = try context.fetch(SavedReceipes.fetchRequest())
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        editableReceipeText.reloadInputViews()
    }
    
}
