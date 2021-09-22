//
//  ScannerViewController.swift
//  MVP
//
//  Created by Sean Murphy on 7/11/21.
//

import UIKit
import Vision
import CoreData

var savedReceipeList = [SavedReceipes]()

class ScannerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scannedText = ""
    var recipeTitleToShow = String()
    var recipeBodyToShow = String()
    var rowNumberToShow = 0
    let uniqueID = UUID().uuidString
    var count = 0
    let CAPACITY = 8
    
    func nonDeletedRecipes() -> [SavedReceipes] {
        var savedReceipeArray = [SavedReceipes]()
        for savedRecipe in savedReceipeList {
            savedReceipeArray.append(savedRecipe)
        }
        return savedReceipeArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        tableView.register(UINib(nibName: "ScannerTableViewCell", bundle: nil), forCellReuseIdentifier: "scannedRecipeDetailsCell")
        tableView.delegate = self
        loadReceipes()
        tableView.reloadData()
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
        newReceipe.uniqueID = uniqueID
        newReceipe.receipe = latestScan 
        self.saveReceipes()
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scannedRecipeDetailsCell", for: indexPath) as! ScannerTableViewCell
        let thisRecipe: SavedReceipes!
        thisRecipe = nonDeletedRecipes()[indexPath.row]
        cell.titleLabel.text = thisRecipe.receipeName ?? "Testing name"
        cell.descriptionLabel.text = thisRecipe.receipe ?? "Testing description"

        cell.accessoryType = .none
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedRecipes().count
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSavedReceipe", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToSavedReceipe") {
            let indexPath = tableView.indexPathForSelectedRow!
            let savedRecipesTSVC = segue.destination as? SavedReceipesToShowVC
            let selectedRecipe: SavedReceipes!
            selectedRecipe = nonDeletedRecipes()[indexPath.row]
            savedRecipesTSVC?.selectedRecipe = selectedRecipe
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    
    //MARK: - Model Manipulation Methods
    
    func saveReceipes() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        loadReceipes()
        tableView.reloadData()
    }
    
    func loadReceipes(with request: NSFetchRequest<NSFetchRequestResult> = SavedReceipes.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let newRecipe = result as! SavedReceipes
//                savedReceipeArray.append(newRecipe)
                savedReceipeList.append(newRecipe)
            }
//            savedReceipeArray = try context.fetch([SavedReceipes.fetchRequest())
            count = nonDeletedRecipes().count
            tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}



