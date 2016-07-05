//
//  SprintCategory.swift
//  TriCore
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation
import RealmSwift

class SprintCategory: Object{
    dynamic var sprintCategoryName = ""
    dynamic var sprintCategoryId = 0
    
    override func primaryKey() -> Int {
        return sprintCategoryId
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        let nextLocation: NSArray = Array(realm.objects(SprintCategory).sorted("id"))
        let last = nextLocation.lastObject
        if nextLocation.count > 0 {
            let currentID = last?.valueForKey("id") as? Int
            return currentID! + 1
        }
        else {
            return 1
        }
    }
}