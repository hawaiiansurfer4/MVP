//
//  SearchHistoryModel.swift
//  MVP
//
//  Created by Sean Murphy on 5/24/21.
//

import UIKit
import CoreData


class SearchHistoryModel {
    private var historyStorage: [String] = []
    private var defaults = UserDefaults.standard
    private var count = 0 {
        didSet {
            if count > CAPACITY {
                self.pop()
            }
        }
    }
    private let CAPACITY = 8

    func push(_ recentlySearched: String) {
        historyStorage.append(recentlySearched)
        defaults.set(historyStorage, forKey: "SearchHistoryArray")
        count+=1
    }

    func pop() -> Void {
        historyStorage.removeFirst()
        defaults.set(historyStorage, forKey: "SearchHistoryArray")
        count-=1
    }

    func searchPopulation() -> [String] {
        if let items = defaults.array(forKey: "SearchHistoryArray") as? [String] {
            historyStorage = items
        }
        return historyStorage.map{$0}.reversed()    }


}

extension SearchHistoryModel: CustomStringConvertible {
    var description: String {
//        var stackElements = historyStorage.map { $0 }.reversed()
        return "called"
    }

}
