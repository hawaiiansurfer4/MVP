//
//  WebPageViewController.swift
//  MVP
//
//  Created by Sean Murphy on 11/11/20.
//

import UIKit
import WebKit
import SafariServices

class WebPageViewController: UIViewController, WKUIDelegate {
    
//    var webPageModel = WebPageModel()
    var recipeManager = RecipeManager()
    static var webShowRecipeURL = String()
    var webView: WKWebView!
    let child = SpinnerViewController()
//    var recipeTableViewController = RecipeTableViewController()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            guard let myURL = URL(string: WebPageViewController.webShowRecipeURL) else { fatalError("Error creating the final recipe URL screen")}
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
        }
        
    }
    
}
    
    //MARK: - Activity Indicator
    
extension WebPageViewController {

    func createSpinnerView() {

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeSpinner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
}


