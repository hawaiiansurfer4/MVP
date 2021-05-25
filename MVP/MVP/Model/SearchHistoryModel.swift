//
//  SearchHistoryModel.swift
//  MVP
//
//  Created by Sean Murphy on 5/24/21.
//

import UIKit

struct SearchHistoryModel<Element> {
    private var historyStorage: [Element] = []
    init() {}
    
    mutating func push(_ element: Element) {
        historyStorage.append(element)
    }
    
    mutating func pop() -> Element? {
        return historyStorage.popLast()
    }
}

extension SearchHistoryModel: CustomStringConvertible {
    var description: String {
        let stackElements = historyStorage.map{$0}.reversed()
        return "called"
    }
    
}
