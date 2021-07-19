//
//  ScannerViewController.swift
//  MVP
//
//  Created by Sean Murphy on 7/11/21.
//

import UIKit
import Vision

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var cameraScannerView: UIImageView!
    @IBOutlet weak var tellUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        tellUser.text = "Press the scan button to take a picture"
        tellUser.numberOfLines = 0
        cameraScannerView.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func cameraScannerButtonPressed(_ sender: UIButton) {
        getImage(fromSourceType: .camera)
//        present(imagePicker, animated: true, completion: nil)
        tellUser.text = ""
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        getImage(fromSourceType: .photoLibrary)
//        present(imagePicker, animated: true, completion: nil)
        tellUser.text = ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            [weak self] in
        
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] {
                self!.cameraScannerView.image = userPickedImage as? UIImage
            
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
            tellUser.text = ""
            if imagePicker.isViewLoaded {
                
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Image Selected", message: "Are you sure that you want to continue with the image that you selected?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
            self.recognizeText(image: self.imagePicker as? UIImage)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined()
            print("here is the text that should be printed \(text)")
        }
        
        do {
            let statementToPrint = try handler.perform([request])
            print("Here is the translated text \(statementToPrint)")
        } catch {
            print(error)
        }
    }
}

    

