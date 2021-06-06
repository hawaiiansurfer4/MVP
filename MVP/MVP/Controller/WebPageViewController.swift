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
    
    static var webShowRecipeURL = String()
    var webView: WKWebView!
    let child = SpinnerViewController()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.webPageStateManagement(WebState.loading)
            guard let myURL = URL(string: WebPageViewController.webShowRecipeURL) else { fatalError("Error creating the final recipe URL screen")}
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
            self.webPageStateManagement(WebState.success)
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

//MARK: - State Management

extension WebPageViewController {

    enum WebState {
        case loading
        case success
        case error
    }

    func webPageStateManagement(_ currentState: WebState) {
        switch currentState {
        case .loading:
            createSpinnerView()
        case .success:
            removeSpinner()
        case .error:
            print("Error with your web page VC State Management")
        }
    }
}


