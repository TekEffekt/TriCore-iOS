//
//  RealmPopulator.swift
//  TriCore
//
//  Created by Alex on 7/9/16.
//  Copyright © 2016 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPopulator {

    static func addTimesheetDetailEntry(
        withOpportunity opp: Opportunity, withSprintCategory category: SprintCategory, withTaskCode code: Taskcode, withTimesheet timesheet:Timesheet) {
        
        let timesheetEntry = TimesheetDetailEntry()
        
        timesheetEntry.opportunity = opp
        timesheetEntry.sprintCategory = category
        timesheetEntry.taskCode = code
        
        timesheetEntry.id = TimesheetDetailEntry.incrementID()

        add(timesheetEntry)
        
        let timesheet = RealmQuery.fetchTimesheets(timesheet.id).first!
        let realm = try! Realm()
        try! realm.write {
            timesheet.entries.append(timesheetEntry)
        }
    }
    
    static func addOpportunity(withOppName name: String) {
        
        let opp = Opportunity()
        opp.name = name
        opp.id = Opportunity.incrementID()
        
        add(opp)
    }
    
    static func addSprintCategory(withSprintName name: String){
        
        let sprintCat = SprintCategory()
        sprintCat.name = name
        sprintCat.id = SprintCategory.incrementID()
        
        
        add(sprintCat)
    }
    
    static func addTaskcode(withTaskcodeName name: String){
        
        let taskcode = Taskcode()
        taskcode.name = name
        taskcode.id = Taskcode.incrementID()
        
        
        add(taskcode)
    }
    
    static func addTimeSheet(){
        
        let timesheet = Timesheet()
        timesheet.id = Timesheet.incrementID()
    
        add(timesheet)
    }
    
    static func add(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
}
