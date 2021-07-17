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
//        tellUser.center = CGPoint(x: CGPoin, y: 0)
//        imagePicker.
        
    }
    
    @IBAction func scannnerButtonPressed(_ sender: UIButton) {
//        if imagePicker != nil {
            present(imagePicker, animated: true, completion: nil)
//        } else {
//            tellUser.text = "Please take a picture or select a picture to continue"
//        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickedImage = info[UIImagePickerController.InfoKey.originalImage]
        cameraScannerView.image = userPickedImage as? UIImage
        
        imagePicker.dismiss(animated: true, completion: nil)
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
    

