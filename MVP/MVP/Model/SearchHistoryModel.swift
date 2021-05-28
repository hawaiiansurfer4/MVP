//
//  SearchHistoryModel.swift
//  MVP
//
//  Created by Sean Murphy on 5/24/21.
//

import UIKit

//struct AppSearchHistory {
//    var historyStorage: [String]
//
//    init(historyStorage: [String]) {
//        self.historyStorage = historyStorage
//    }
//}

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
//    var historyStorage = [String]()

//    init() {}
//    var historyStorage = AppSearchHistory.init(historyStorage: [])

//    mutating func capacity() {
//        var totalCapcity = historyStorage.count {
//            didSet {
//                if historyStorage.count == 8 {
//                    self.pop()
//                }
//            }
//        }
//        print(historyStorage)
//    }

    func push(_ recentlySearched: String) {
        historyStorage.append(recentlySearched)
        count+=1
//        print(historyStorage)
    }

    func pop() -> Void {
        historyStorage.removeFirst()
        count-=1
    }

    func searchPopulation() -> [String] {
//        var stackElements = Array(historyStorage.map{$0}.reversed())
//        var stackElements = [String]()
//        for search in historyStorage {
//            stackElements.append(search)
//        }

        return historyStorage.map{$0}.reversed()    }


}

extension SearchHistoryModel: CustomStringConvertible {
    var description: String {
//        var stackElements = historyStorage.map { $0 }.reversed()
        return "called"
    }

}
