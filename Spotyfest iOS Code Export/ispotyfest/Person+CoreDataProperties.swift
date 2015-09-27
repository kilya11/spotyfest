//
//  Person+CoreDataProperties.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {
  
  @NSManaged var name: String?
  @NSManaged var location: String?
  @NSManaged var imageID: String?
  @NSManaged var email: String?
  @NSManaged var bid: NSNumber?
  @NSManaged var ask: NSNumber?
  @NSManaged var acceptedName: String?
  @NSManaged var activeSince: NSDate?
  
}
