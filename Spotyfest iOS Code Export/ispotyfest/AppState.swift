//
//  AppState.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-27.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import Foundation

class AppState: NSObject {
  
  var person: Person?
  
  override init() {
    super.init()
    person = Person.newObject()
  }
  
}