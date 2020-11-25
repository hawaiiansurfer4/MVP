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
            self.webView.load(myRequest)
        }
        
    }
    
    
//    func Recipe() {
//
//        recipeManager.
//    }
//
//    func showRecipeOnScreen(webPageView: Data) {
//
//    }
//    override func loadFileURL(_ URL: URL, allowingReadAccessTo readAccessURL: URL) -> WKNavigation? {
//        web
//    }
}
