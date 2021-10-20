//
//  Filters.swift
//  MVP
//
//  Created by Sean Murphy on 10/19/21.
//

import CoreData

@objc (Filters)
class Filters: NSManagedObject {
    @NSManaged var category: String!
    @NSManaged var filter: String!
    @NSManaged var filterString: String!
    var selectedFilter: Bool?
    
}
