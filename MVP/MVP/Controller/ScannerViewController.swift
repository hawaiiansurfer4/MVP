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
    var rowNumberToShow = 0
    var count = 0 {
        didSet {
            if count > CAPACITY {
                context.delete(savedReceipeList.removeFirst())
                saveReceipes()
            }
        }
    }
    let CAPACITY = 8
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        tableView.register(UINib(nibName: "ScannerTableViewCell", bundle: nil), forCellReuseIdentifier: "scannedRecipeDetailsCell")
        tableView.delegate = self
        if(firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedReceipes")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let savedRecipe = result as! SavedReceipes
                    savedReceipeList.append(savedRecipe)
                }
                count = savedReceipeList.count
            } catch {
                print("Fetch Failed")
            }
        }
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
        let entity = NSEntityDescription.entity(forEntityName: "SavedReceipes", in: context)
        let newReceipe = SavedReceipes(entity: entity!, insertInto: context)
        newReceipe.receipe = latestScan
        newReceipe.receipeName = "Name this recipe"
        savedReceipeList.append(newReceipe)
        count = savedReceipeList.count
        self.saveReceipes()
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scannedRecipeDetailsCell", for: indexPath) as! ScannerTableViewCell
        cell.titleLabel.text = savedReceipeList[indexPath.row].receipeName
        cell.descriptionLabel.text = savedReceipeList[indexPath.row].receipe
        cell.accessoryType = .none
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedReceipeList.count
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSavedReceipe", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToSavedReceipe") {
            let indexPath = tableView.indexPathForSelectedRow!
            let savedRecipesTSVC = segue.destination as? SavedReceipesToShowVC
            let selectedRecipe = savedReceipeList[indexPath.row]
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
        tableView.reloadData()
    }
}


