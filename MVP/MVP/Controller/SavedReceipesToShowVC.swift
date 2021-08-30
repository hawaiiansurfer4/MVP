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
//    let savedEditableReceipeID = 
    var recipeTitle: String? {
        didSet {
            print("Line 27")
//            saveReceipes()
        }
    }
    var recipeRowNumberToShow: Int?
    var showThisRecipe: String? {
        didSet {
            print("Line 34")
//            saveReceipes()
        }
    }
    var labelLongPressEnabled = false
    var editableLongPressEnabled = false
    var uniqueID = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableReceipeText.delegate = self
        recipeTitleLabel.delegate = self
        recipeTitleLabel.isUserInteractionEnabled = true
        recipeTitleLabel.snapshotView(afterScreenUpdates: false)
        editableReceipeText.snapshotView(afterScreenUpdates: false)
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
            editableLongPressEnabled = true
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
            recipeTitleLabel.clearsContextBeforeDrawing = true
            sender.state = .ended
        }
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
                updateUI(label: text, textViewContent: recipeBody)
                updateEditedRecipe(text, recipeBody)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text {
//            print("Line 120 @@@@@@@@@@@@@ \(text)")
//            recipeTitle = text
//            updateEditedTitle(text)
//            recipeTitleLabel.resignFirstResponder()
//        }
        saveReceipes()
//        editableReceipeText.resignFirstResponder()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
//    func updateEditedRecipeBody(_ editedRecipe: String) {
//        let recipeUpdate = SavedReceipes(context: context)
//        recipeUpdate.receipe = editedRecipe
//        saveReceipes()
//    }
    
    func updateEditedRecipe(_ newName: String, _ newBody: String) {
        let titleUpdate = SavedReceipes(context: context)
        titleUpdate.receipeName = newName
        titleUpdate.receipe = newBody
//        titleUpdate.uniqueID
        saveReceipes()
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
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        <#code#>
//    }


    func textViewDidChange(_ textView: UITextView) {
//        saveReceipes()
    }

    
    
    //MARK: - Model Manipulation Methods
    
    func saveReceipes() {
        
//        let savedRecipesEntity = NSEntityDescription.entity(forEntityName: "SavedReceipes", in: context)!
//        let updatedValue = NSManagedObject(entity: savedRecipesEntity, insertInto: context)
//        updatedValue.setValue(recipeTitle, forKeyPath: "receipeName")
//        updatedValue.setValue(showThisRecipe, forKey: "receipe")
        
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
            
//            self.editableReceipeText.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow!].receipe
//            self.recipeTitleLabel.text = self.savedEditableReceipeArray[self.recipeRowNumberToShow!].receipeName
            self.editableReceipeText.reloadInputViews()
        }
        
    }
    
}

