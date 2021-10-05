//
//  SavedReceipes.swift
//  MVP
//
//  Created by Sean Murphy on 8/30/21.
//

import CoreData

@objc (SavedReceipes)
class SavedReceipes: NSManagedObject {
    @NSManaged var receipe: String!
    @NSManaged var receipeName: String!
    @NSManaged var uniqueID: String!
    
}
