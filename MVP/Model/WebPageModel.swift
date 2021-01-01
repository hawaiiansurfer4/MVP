//
//  WebPageModel.swift
//  MVP
//
//  Created by Sean Murphy on 11/10/20.
//

import UIKit

protocol WebPageDelegate {
    
    func webViewDidFail(error: Error)
}

struct WebPageModel {
    
    var webDelegate: WebPageDelegate?

}
