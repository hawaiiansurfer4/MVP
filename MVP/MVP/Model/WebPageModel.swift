//
//  WebPageModel.swift
//  MVP
//
//  Created by Sean Murphy on 11/10/20.
//

import UIKit

protocol WebPageDelegate {
//    func updateWebPageView(webViewURLString: String)
    func webViewDidFail(error: Error)
}

struct WebPageModel {
    
//    var webPageViewController = WebPageViewController()
    var webDelegate: WebPageDelegate?
    func fetchFinalWebpage(webURL: String) {
        if let url = URL(string: webURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.webDelegate?.webViewDidFail(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    return
                }
            }
            task.resume()
        }
    }

}
