//
//  RealmQuery.swift
//  TriCore
//
//  Created by Alex on 7/9/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation
import RealmSwift

class RealmQuery {
    static func fetchTimeSheetDetailEntries(withEntryId: Int) -> [TimesheetDetailEntry] {
        let realm = try! Realm()
        
        let allTimesheetDetailEntries = realm.objects(TimesheetDetailEntry).filter("id = \(withEntryId)")

        return Array(allTimesheetDetailEntries)
    }
    
    static func fetchTimesheets (withSheetId: Int) -> [Timesheet] {
        let realm = try! Realm()
        
        let allTimesheets = realm.objects(Timesheet).filter("id = \(withSheetId)")
        
        return Array(allTimesheets)
    }
    
    static func fetchTaskcodes(withCodeId: Int) -> [Taskcode] {
        let realm = try! Realm()
        
        let allTaskcodes = realm.objects(Taskcode).filter("id = \(withCodeId)")
        
        return Array(allTaskcodes)
    }
    
    static func fetchSpringCategories (withCategoryId: Int) -> [SprintCategory] {
        let realm = try! Realm()
        
        let allSprintCategories = realm.objects(SprintCategory).filter("id = \(withCategoryId)")
        
        return Array(allSprintCategories)
    }
    
    static func fetchOpportunities (withOppId: Int) -> [Opportunity] {
        let realm = try! Realm()
        
        let allOpportunities = realm.objects(Opportunity).filter("id = \(withOppId)")
        
        return Array(allOpportunities)
    }
    
    
}