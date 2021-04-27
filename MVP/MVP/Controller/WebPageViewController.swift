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
            self.createSpinnerView()
            guard let myURL = URL(string: WebPageViewController.webShowRecipeURL) else { fatalError("Error creating the final recipe URL screen")}
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
        }
        
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

