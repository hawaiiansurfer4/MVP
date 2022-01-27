//
//  Filters.swift
//  MVP
//
//  Created by Sean Murphy on 10/19/21.
//

import CoreData

@objc (Filters)
class Filters: NSManagedObject {
    @NSManaged var categoryTitle: String!
    @NSManaged var filter: String!
    @NSManaged var id: String!
    var isSelected: Bool!
    
}
