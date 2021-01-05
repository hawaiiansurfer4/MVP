////
////  LoadingCircle.swift
////  MVP
////
////  Created by Sean Murphy on 12/17/20.
////
//
//import Foundation
//import UIKit
//
//enum State {
//    case loading
//    case sucess
//    case error
//}
//
//protocol LoadingManagerDelegate {
//    func didUpdateLoadingScreen(_ loadingManager: LoadingManager)
//    func didFailLoadingError(error: Error, loadingManager: LoadingManager)
//}
//
//
//struct LoadingManager {
//    var indicator = UIActivityIndicatorView(frame: CoreGraphics.CGRect(x: 0, y: 0, width: 100, height: 100))
//    var delegate: LoadingManagerDelegate?
//
//    func startLoadingScreen(state: State) {
//        switch state {
//        case .loading:
//            indicator.style = UIActivityIndicatorView.Style.large
//            indicator.startAnimating()
//            indicator.color = UIColor.green
//            indicator.backgroundColor = UIColor.clear
////            view.center = self.view.center
////            self.view.addSubview(indicator)
//            indicator.hidesWhenStopped = true
//        case .sucess:
//            indicator.stopAnimating()
//        case .error:
//            let alert = UIAlertController(title: "Error", message: "Invalid Search! Please check spelling and try again!", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
////            self.present(alert, animated: true, completion: nil)
//        }
//
//    }
//
//}
