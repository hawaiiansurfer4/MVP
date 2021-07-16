//
//  ScannerViewController.swift
//  MVP
//
//  Created by Sean Murphy on 7/11/21.
//

import UIKit
import Vision

class ScannerViewController: UIViewController  {
    
    
    
    
    @IBOutlet weak var cameraScanner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func scannnerButtonPressed(_ sender: UIButton) {
        
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
    

