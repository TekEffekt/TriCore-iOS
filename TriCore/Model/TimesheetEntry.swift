//
//  TimesheetEntry.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/25/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class TimesheetEntry
{
    let projectName:String
    let taskCode:String
    let sprintCategory:String?
    
    init(withProjectName name:String, andTaskCode taskCode:String, andSprint sprintCategory:String?)
    {
        self.projectName = name
        self.taskCode = taskCode
        
        if let sprintCategory = sprintCategory
        {
            self.sprintCategory = sprintCategory
        } else
        {
            self.sprintCategory = nil
        }
    }
    
}
