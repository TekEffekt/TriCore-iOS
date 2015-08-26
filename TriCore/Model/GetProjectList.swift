//
//  GetProjectList.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/12/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//
//  WARNING. THIS SHIT IS BADLY WRITTEN.

import Foundation

class GetProjectList
{
    static let letterList = ["A","B","C","D","E","F","G","H","I","J","K",
        "L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    static func getOrganizedProjectList() -> [[String:AnyObject]]
    {
        var projectList = [[String: AnyObject]]()
        
        for letter in letterList
        {
            var dictionary = [String: AnyObject]()
            dictionary["Letter"] = letter
            dictionary["Entries"] = [TimesheetEntry]()
            
            projectList.append(dictionary)
        }
        
        for name in Constants.projectNames
        {
            let firstLetter = self.findFirstLetter(inString: name)
            let index = letterList.indexOf(firstLetter)
            
            let taskCode = self.getRandomTaskCode()
            let sprintCat = self.getRandomSprintCategory()
            
            let entry = TimesheetEntry(withProjectName: name, andTaskCode: taskCode, andSprint: sprintCat)
            
            var dictionaryForLetter:[String:AnyObject] = projectList[index!]
            var entryArray:[TimesheetEntry] = dictionaryForLetter["Entries"] as! [TimesheetEntry]
            entryArray.append(entry)
            dictionaryForLetter["Entries"] = entryArray
            projectList[index!] = dictionaryForLetter
        }
        
        var shreddedList = [[String: AnyObject]]()
        
        for var i = 0; i < projectList.count; i++
        {
            let dict = projectList[i]
            if dict["Entries"]!.count > 0
            {
                shreddedList.append(dict)
            }
        }
        
        return shreddedList
    }
    
    static func findFirstLetter(inString string:String) -> String
    {
        for char in string.characters
        {
            let str = String(char)
            if letterList.contains(str)
            {
                return str
            }
        }
        
        return ""
    }
    
    static func removeEmptyArrays(var inList projectList:[[String: AnyObject]])
    {
//        for dict in projectList
//        {
//            if dict["Entries"]!!.count == 0
//            {
//                projectList.removeAtIndex(projectList.indexOf(dict))
//            }
//        }
    }
    
    static func getRandomTaskCode() ->String
    {
        let randomIndex = Int(arc4random_uniform(UInt32(Constants.taskCodeNames.count)))
        return Constants.taskCodeNames[randomIndex]
    }
    
    static func getRandomSprintCategory() ->String
    {
        let randomIndex = Int(arc4random_uniform(UInt32(Constants.sprintNames.count)))
        return Constants.sprintNames[randomIndex]
    }
    
    
}