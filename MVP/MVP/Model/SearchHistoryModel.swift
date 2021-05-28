//
//  SearchHistoryModel.swift
//  MVP
//
//  Created by Sean Murphy on 5/24/21.
//

import UIKit


class SearchHistoryModel {
    private var historyStorage: [String] = []
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
        count+=1
    }

    func pop() -> Void {
        historyStorage.removeFirst()
        count-=1
    }

    func searchPopulation() -> [String] {

        return historyStorage.map{$0}.reversed()    }


}

extension SearchHistoryModel: CustomStringConvertible {
    var description: String {
//        var stackElements = historyStorage.map { $0 }.reversed()
        return "called"
    }

}
