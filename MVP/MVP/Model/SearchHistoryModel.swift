//
//  SearchHistoryModel.swift
//  MVP
//
//  Created by Sean Murphy on 5/24/21.
//

import UIKit

struct SearchHistoryModel {
    private var historyStorage: [String] = []
    init() {}
    
    mutating func capacity() {
        var totalCapcity = historyStorage.count {
            didSet {
                if historyStorage.count == 8 {
                    self.pop()
                }
            }
        }
    }
    
    mutating func push(_ recentlySearched: String) {
        historyStorage.append(recentlySearched)
    }
    
    mutating func pop() -> String? {
        return historyStorage.popLast()
    }
    
    mutating func searchPopulation() -> [String] {
        var stackElements = Array(historyStorage.map{$0}.reversed())
        return stackElements
    }
    

}

extension SearchHistoryModel: CustomStringConvertible {
    var description: String {
        var stackElements = historyStorage.map{$0}.reversed()
        return "called"
    }
    
}
