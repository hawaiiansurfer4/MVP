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
        imagePicker.sourceType = .camera
        tellUser.text = "Press the scan button to take a picture"
        tellUser.numberOfLines = 0
        
    }
    
    @IBAction func cameraScannerButtonPressed(_ sender: UIButton) {
        getImage(fromSourceType: .camera)
        present(imagePicker, animated: true, completion: nil)
        tellUser.text = ""
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        getImage(fromSourceType: .photoLibrary)
        present(imagePicker, animated: true, completion: nil)
        tellUser.text = ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            [weak self] in
        
        let userPickedImage = info[UIImagePickerController.InfoKey.originalImage]
            self!.cameraScannerView.image = userPickedImage as? UIImage
        
            self!.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNDetectTextRectanglesRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined()
        }
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

//MARK: - Scanner camera access code

//Show alert to selected the media source type.
//   private func showAlert() {
//
//       let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
//       alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//           self.getImage(fromSourceType: .camera)
//       }))
//       alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
//           self.getImage(fromSourceType: .photoLibrary)
//       }))
//       alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//       self.present(alert, animated: true, completion: nil)
//   }


   //MARK:- UIImagePickerViewDelegate.
//   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//       self.dismiss(animated: true) { [weak self] in
//
//           guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//           //Setting image to your image view
//           self?.profileImgView.image = image
//       }
//   }
//
//   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//       picker.dismiss(animated: true, completion: nil)
//   }

    

