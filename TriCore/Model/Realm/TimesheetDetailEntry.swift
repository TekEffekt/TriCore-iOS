//
//  TimesheetEntry.swift
//  TriCore
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation
import RealmSwift

class TimesheetDetailEntry: Object{
    
    dynamic var opportunity: Opportunity? = Opportunity()
    dynamic var sprintCategory: SprintCategory? = SprintCategory()
    dynamic var taskCode: Taskcode? = Taskcode()
    dynamic var monday = 0
    dynamic var tuesday = 0
    dynamic var wednesday = 0
    dynamic var thursday = 0
    dynamic var friday = 0
    dynamic var saturday = 0
    dynamic var sunday = 0
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func incrementID() -> Int {
        let realm = try! Realm()
        let nextLocation: NSArray = Array(realm.objects(TimesheetDetailEntry).sorted("id"))
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
