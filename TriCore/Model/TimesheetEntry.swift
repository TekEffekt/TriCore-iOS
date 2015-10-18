//
//  TimesheetEntry.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/25/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  This is the model object that represents each entry in the timesheet

import UIKit

class TimesheetEntry:NSObject
{
    let projectName:String
    let taskCode:String
    let sprintCategory:String?
    var hours:[Int?] = []
    
    init(withProjectName name:String, andTaskCode taskCode:String, andSprint sprintCategory:String?)
    {
        self.projectName = name
        self.taskCode = taskCode
        
        if let sprintCategory = sprintCategory
        {
            self.sprintCategory = sprintCategory
        } else
        {
            self.sprintCategory = ""
        }
        
        for _ in 1...7
        {
            hours.append(nil)
        }
    }
    
}
