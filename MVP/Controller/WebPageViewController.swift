//
//  WebPageViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/11/20.
//

import UIKit
import WebKit
import SafariServices

enum State {
    case loading
    case sucess
    case error
}

class WebPageViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
//    var webPageModel = WebPageModel()
//    var loadingManager = LoadingManager()
    var recipeManager = RecipeManager()
    static var webShowRecipeURL = String()
    var webView = WKWebView()
    let webConfiguration = WKWebViewConfiguration()
    
    override func loadView() {
//        loadingManager.startLoadingScreen(state: .loading)
        
        
//        self.webView.navigationDelegate = self
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webConfiguration.allowsPictureInPictureMediaPlayback = true
        webView.navigationDelegate = self
        view = webView
        startLoadingScreen(state: .loading)
    }
    
    func startLoadingScreen(state: State) {
//        let pending = UIAlertController(title: "Creating New User", message: nil, preferredStyle: .alert)
//        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        let indicator = UIActivityIndicatorView(frame: webView.bounds.standardized)
        switch state {
        case .loading:
            
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
//            add the activity indicator as a subview of the alert controller's view
//            pending.view.addSubview(indicator)
            indicator.isUserInteractionEnabled = false
//            required otherwise if there buttons in the UIAlertController you will not be able to press them
            indicator.style = UIActivityIndicatorView.Style.large
            indicator.color = UIColor.green
            indicator.backgroundColor = UIColor.clear
            indicator.center = self.view.center
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
            webView.addSubview(indicator)
            
        case .sucess:
//            pending.addAction(.init(title: "Creating New User", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(indicator)
                indicator.isUserInteractionEnabled = true
                indicator.isHidden = true
//                indicator.is
                indicator.stopAnimating()
                self.webView.didMoveToSuperview()
//                self.webView.
//                self.webView.debugDescription
//                self.webView.setNeedsLayout() = pending.
            }
        case .error:
            let alert = UIAlertController(title: "Error", message: "Invalid Search! Please check spelling and try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }

    
    func grabURLForRecipeScreen(urlString: String?) {
//        if let url = urlString {
//            webShowRecipeURL = url
//            print("Here is the webShowRecipeURL \(webShowRecipeURL)")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            guard let myURL = URL(string: WebPageViewController.webShowRecipeURL) else { fatalError("Error creating the final recipe URL screen")}
            let myRequest = URLRequest(url: myURL)
//            self.loadingManager.startLoadingScreen(state: .sucess)
            self.startLoadingScreen(state: .sucess)
            self.webView.load(myRequest)
        }
        
    }
    
}

//MARK: - LoadingManagerDelegate
//extension WebPageViewController: LoadingManagerDelegate {
//    func didFailLoadingError(error: Error, loadingManager: LoadingManager) {
//        loadingManager.startLoadingScreen(state: .error)
//        print("Error in WebPage loading \(error)")
//    }
//
//    func didUpdateLoadingScreen(_ loadingManager: LoadingManager) {
//        DispatchQueue.main.async {
//            let viewSet = loadingManager.indicator
//            viewSet.center = self.view.center
//            self.view.addSubview(loadingManager.indicator)
//        }
//    }
//}

