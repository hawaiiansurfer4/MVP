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
    
    //MARK: - GestureLongPressRecognition
    
    @IBAction func longPressEditableReceipeText(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            sender.minimumPressDuration = 3
        }
        if sender.minimumPressDuration == 3 {
            editableReceipeText.becomeFirstResponder()
        }
    }
    
    @IBAction func longPressRecipeTitleLabel(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            sender.minimumPressDuration = 3
        }
        if sender.minimumPressDuration == 3 {
            recipeTitleLabel.becomeFirstResponder()
        }
//        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//            return true
//        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    //MARK: - UITextField
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recipeTitleLabel.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        recipeTitleLabel.resignFirstResponder()
//        saveReceipes()
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        recipeTitleLabel.resignFirstResponder()
//        editableReceipeText.resignFirstResponder()
        saveReceipes()
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
    
    
    func textViewDidChange(_ textView: UITextView) {
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

