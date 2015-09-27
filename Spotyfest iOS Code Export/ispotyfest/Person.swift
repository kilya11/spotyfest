//
//  Person.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  
  static func newObject() -> Person {
    return Person.newObject(nil)
  }
  
  static func newObject(initData: NSData?) -> Person {
    let newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: SharedAppDelegate().managedObjectContext) as! Person
    newPerson.activeSince = NSDate()
    
    if initData != nil {
      let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(initData!)! as! NSDictionary
      if dictionary.valueForKey("name") != nil {
        newPerson.name = (dictionary.valueForKey("name") as! String)
      }
      if dictionary.valueForKey("email") != nil {
        newPerson.email = (dictionary.valueForKey("email") as! String)
      }
      if dictionary.valueForKey("location") != nil {
        newPerson.location = (dictionary.valueForKey("location") as! String)
      }
      if dictionary.valueForKey("ask") != nil {
        newPerson.ask = (dictionary.valueForKey("ask") as! NSNumber)
      }
      if dictionary.valueForKey("bid") != nil {
        newPerson.ask = (dictionary.valueForKey("bid") as! NSNumber)
      }
    }
    
    return newPerson
  }
  
  func serialize() -> NSData {
    let serializationDictionary: [String: AnyObject] = ["name": name!, "email": email!, "location": location!, "ask": ask!, "bid": bid!]
    return NSKeyedArchiver.archivedDataWithRootObject(serializationDictionary)
    
  }
  
}
