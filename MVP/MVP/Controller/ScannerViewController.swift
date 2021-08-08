//
//  ScannerViewController.swift
//  MVP
//
//  Created by Sean Murphy on 7/11/21.
//

import UIKit
import Vision
import CoreData

class ScannerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    let imagePicker = UIImagePickerController()
    var savedReceipeArray = [SavedReceipes]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let context = NSEntityDescription.insertNewObject(forEntityName: "SavedReceipes", into: NSManagedObjectContext) as! RecipeContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var scannedText = ""
    
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
//        tellUser.text = "Press the scan button to take a picture"
//        tellUser.numberOfLines = 0
        
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
            
//            getImage(fromSourceType: userPickedImage )
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
    
//    func showAlert() {
//        let alert = UIAlertController(title: "Image Selected", message: "Are you sure that you want to continue with the image that you selected?", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
//            self.recognizeText(image: self.imagePicker as? UIImage)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }

//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func recognizeText(image: UIImage?) {
//        guard let cgImage = image?.cgImage else { return }
        
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        
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
                
//                print("Found this candidate: \(text.string)")
                compactedString.append(text.string)
//                self?.updateReceipe()
            }
            self?.scannedText = compactedString.joined(separator: " ")
            print("Here is the completed scan \(self?.scannedText)")
            
//            let text = observations.compactMap({
//                $0.topCandidates(1).first?.string
//            }).joined(separator: " ")
//            print("###################   here is the text that should be printed \(text)")
//            DispatchQueue.main.async {
//                self?.updateReceipe(text)
//            }
//            self.updateReceipe(text)
        }
//        guard let completedScan = scannedText else { return }
        request.recognitionLevel = .accurate
        let requests = [request]
        DispatchQueue.global(qos: .userInitiated).async {
            guard let cgImage = image?.cgImage else {
                fatalError("Missing image to scan")
            }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [ : ])
            let testing = try? handler.perform(requests)
//            print("HERE IS THE TESTING $$$$%%%#%#%#%$%$%$%$%#%#%$%$%$% \(testing)")
            self.updateReceipe(self.scannedText)
        }

//        let convert = request.results
//        print("Here is the conversion @@@@@@@@@ \(convert)")
//        do {
//            let statementToPrint = try handler.perform([request])
//            print("$$$$$$$$$$$$$$$$$$    Here is the translated text \(statementToPrint)")
//        } catch {
//            print(error)
//        }
    }
    
    func updateReceipe(_ latestScan: String) {
        DispatchQueue.main.async {
            let newReceipe = SavedReceipes(context: self.context)
            newReceipe.receipe = latestScan
//            do {
//                try self.context.save()
//            } catch {
//                print("You done fucked up")
//            }
            self.saveReceipes()
            self.loadReceipes()
        }
//        let newReceipe = SavedReceipes(context: context)
//        newReceipe.receipe = latestScan
//        do {
//            try context.save()
//        } catch {
//            print("You done fucked up")
//        }
////        self.saveReceipes()
//        self.loadReceipes()
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedReceipeCell")
        cell?.textLabel?.text = savedReceipeArray[indexPath.row].receipe
        cell?.textLabel?.numberOfLines = 0
        cell?.accessoryType = .none
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return savedReceipeArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func loadReceipes(with request: NSFetchRequest<SavedReceipes> = SavedReceipes.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            savedReceipeArray = try context.fetch(SavedReceipes.fetchRequest())
            count = savedReceipeArray.count
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
}

    

