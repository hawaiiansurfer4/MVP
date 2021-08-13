//
//  ScannerViewController.swift
//  MVP
//
//  Created by Sean Murphy on 7/11/21.
//

import UIKit
import Vision
import CoreData

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var savedReceipesTableOverlay: UITableView!
    let imagePicker = UIImagePickerController()
    var savedReceipeArray = [SavedReceipes]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scannedText = ""
    var recipeTitleToShow = String()
    var recipeBodyToShow = String()
    var rowNumberToShow = 0
//    var savedRecipesToShowVC = SavedReceipesToShowVC()
    
    var count = 0 {
        didSet {
            if count > CAPACITY {
                context.delete(savedReceipeArray.removeFirst())
                saveReceipes()
            }
        }
    }
    let CAPACITY = 8
    
//    @IBOutlet weak var tellUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        savedReceipesTableOverlay.delegate = self
        savedReceipesTableOverlay.dataSource = self
        savedReceipesTableOverlay.becomeFirstResponder()
        savedReceipesTableOverlay.reloadInputViews()
        loadReceipes()
    }
    
    @IBAction func cameraScannerButtonPressed(_ sender: UIBarButtonItem) {
        getImage(fromSourceType: .camera)
    }
   
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        getImage(fromSourceType: .photoLibrary)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            [weak self] in
        
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] {
            
                self!.imagePicker.dismiss(animated: true, completion: nil)
                self?.recognizeText(image: userPickedImage as! UIImage)
            }
        }
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
            if imagePicker.isViewLoaded {
                
            }
        }
    }

//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func recognizeText(image: UIImage?) {
        
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                fatalError("Received invalid observations \(error)")
            }
            var compactedString: [String] = []
            for observation in observations {
                guard let text = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }
                compactedString.append(text.string)
            }
            self?.scannedText = compactedString.joined(separator: " ")
            
        }
        request.recognitionLevel = .accurate
        let requests = [request]
            guard let cgImage = image?.cgImage else {
                fatalError("Missing image to scan")
            }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [ : ])
            if let testing = try? handler.perform(requests) {
                self.updateReceipe(self.scannedText)
        }

    }
    
    func updateReceipe(_ latestScan: String) {
        let newReceipe = SavedReceipes(context: context)
        newReceipe.receipe = latestScan
        self.saveReceipes()
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedReceipeCell", for: indexPath)
        cell.textLabel?.text = savedReceipeArray[indexPath.row].receipe ?? "NOthing to show for the table"
        DispatchQueue.main.async {
            if let recipeBody = self.savedReceipeArray[indexPath.row].receipe {
                self.recipeBodyToShow = recipeBody
            }
            if let recipeTitle = self.savedReceipeArray[indexPath.row].receipeName {
                self.recipeTitleToShow = recipeTitle
            }
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedReceipeArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let savedRecipesTSVC = segue.destination as! SavedReceipesToShowVC
        if let indexPath = savedReceipesTableOverlay.indexPathForSelectedRow {
            guard let savedTextToPass = savedReceipeArray[indexPath.row].receipe else {
                print("%%%%% Here is whats being passed \(savedReceipeArray[indexPath.row].receipe)")
                return
            }
            savedRecipesTSVC.showThisRecipe = savedTextToPass
            savedRecipesTSVC.recipeTitle = savedReceipeArray[indexPath.row].receipeName ?? "Name this recipe"
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        prepare(for: <#T##UIStoryboardSegue#>, sender: <#T##Any?#>)
//        DispatchQueue.main.async {
//            self.rowNumberToShow = indexPath.row
//        }
        performSegue(withIdentifier: "goToSavedReceipe", sender: indexPath.row)
//        savedRecipesToShowVC.recipeRowNumberToShow = savedReceipesTableOverlay[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveReceipes() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        loadReceipes()
        savedReceipesTableOverlay.reloadData()
    }
    
    func loadReceipes(with request: NSFetchRequest<SavedReceipes> = SavedReceipes.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            savedReceipeArray = try context.fetch(SavedReceipes.fetchRequest())
            count = savedReceipeArray.count
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        savedReceipesTableOverlay.reloadData()
    }
}

//MARK: - DidUpdateRecipesToShow

//extension ScannerViewController: RecipeToShowDelegate {
//    func didUpdateEditableRecipe(recipeToShowVC: SavedReceipesToShowVC, rowNumber: Int) {
//        DispatchQueue.main.async {
////            recipeToShowVC.recipeDetailsToShow(recipeBody: self.recipeBodyToShow, recipeTitle: self.recipeTitleToShow)
//            recipeToShowVC.recipeRowNumberToShow = self.rowNumberToShow
//        }
//    }
//    
//    func errorUpdatingEditableRecipe(error: Error) {
//        print("Error updating Editable Recipe")
//        print(error)
//    }
//    
//}

