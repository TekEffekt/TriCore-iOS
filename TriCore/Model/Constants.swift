//
//  Constants.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/16/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import Foundation

class Constants
{
    static let weekNameStrings = ["Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"]
    
    static let organizedProjectNames =
    [["C", ["5028-00-Coca Cola Refreshments - Twinsburg - CIP Chemical Pump Modifications",
        "6899-00-Coca Cola Refreshments - Indianapolis - Blender Sugar Tracking",
        "6931-00-Coca Cola Refreshments - Brampton - Control System Training", "7015-00-Coca Cola Refreshments - Phoenix - Sucrose Addition",
         "7021-00-Coca Cola Refreshments - Cincinnati - Sucrose Addition"]],
    ["G", ["7020-00-Gehl Foods, Inc - Historian Notifications"]],
    ["K", ["6985-00-Kroger - Crossroad Farms Dairy - Sanitizer Dosing"]],
    ["P", ["6973-00-Portion Pac - Jacksonville - Kitchen Batching System"]],
    ["S", ["6932-00-Sunny Delight Beverages Co. - Littleton - System Training", "6948-00-Sunny Delight Beverages Co. - Littleton - Plant Specific Automation Training"]]   ]
    
    static let organizedTaskCodeNames = [
        ["A", ["ADMN:Administration", "ADMN:Purchasing", "ADMN:Shipping", "ADMN:HR/Payroll", "ADMN:Accounts Receivable", "ADMN:Travel Arrangements",
            "ADMN:Accounts Payable", "ADMN:CRM Activities"]],["B", ["BI:Help Desk", "BI:Hardware Setup", "BI:Reporting","BI:HMI Scripting","BI:Programming","BI:BI Other","BI:Data Entry","BI:Data Integration","BI:Meeting Travel","BI:Communication Program","BI:MES Programming","BI:VB Programming",
    "BI:Database Programming"]], ["D", ["DOC:Functional Specification","DOC:Software Design Specification","DOC:Hardware Design Specification",
    "DOC:System Acceptance Test Specification","DOC:Documentation","DOC:Other"]], ["E", [
    "EE:Panel Assembly","EE:Panel Checkout","EE:UL Labeling","EE:Bill of Material","EE:Electrical Engineering","EE:I/O Map","EE:EE I/O Schematics","EE:EE Power Distribution","EE:EE Panel Layouts","EE:EE Specifications","EE:EE Purchase Requests",
    "EE:Commercial Project Leader","EE:Expediting","EE:Receiving"]], ["F", ["FD:Functional Description",
    "FD:Software Analysis Design"]], ["H", ["HMI:OPER Interface Programing",
    "HMI:HMI Programming","HMI:HMI Line Painiting","HMI:HMI P&ID Graphics","HMI:HMI Trending","HMI:HMI Manual-Off-Auto","HMI:HMI Setpoints","HMI:HMI Permissives","HMI:HMI Graphics","HMI:HMI Controls","HMI:OIT Graphics","HMI:OIT Controls",
    "HMI:System Configuration- Hardware and Software"]], ["I", [
    "IT:Hardware and Software Configuration","IT:Break/Fix","IT:Facility","IT:Infrastructure","IT:Projects","IT:Asset Tracking","IT:Purchasing"]], ["M", ["MEET:Project In-House Meeting","MEET:Sales Meeting","MEET:Other Meeting","MEET:Project Site Meeting","MISC:Unpaid Time","MISC:Flex Time","MISC:Evaluations",
    "MISC:Floating Holiday","MISC:Unassigned","MISC:Recruiting","MISC:IT - Phone System","MISC:IT - Infrastructure","MISC:IT - Server Maintenance","MISC:IT - Projects","MISC:Comp. Time",
    "MISC:Documentation","MISC:Panel Assembly","MISC:Crating","MISC:Miscellaneous","MISC:Research","MISC:Contract Service","MISC:Engraving","MISC:Consulting",
    "MISC:General Training","MISC:IT - Break/Fix","MISC:Fat Testing","MISC:Software Design Spec.","MISC:Hardware Design Spec.","MISC:SW Accept Test Spec.","MISC:Holiday",
    "MISC:Vacation","MISC:Sick Time","MISC:Snow Day","MISC:Funeral","MISC:Jury Duty","MISC:Short Term Disability"]], ["P", [
    "PDEV:Targeted Training","PLC:System Set Up","PLC:PLC Programming","PM:Project Management","PM:Finanacial","PM:Tech Project Mgmt","PM:Meeting",
    "PM:Engineering Project Management"]], ["Q", ["QA:Individual Testing","QA:Group Testing",
    "QA:Software Simulation","QA:Quality Assurance"]], ["S", ["SALE:Pre Project Engineering","SALE:Proposals","SALE:Sales","SALE:Marketing","SALE:Entertainment",
    "SERV:Preventive Maintenance","SERV:Demand Service","SERV:Software Improvement Module","SERV:Technical Support",
    "SITE:Support","SITE:Calibration","SITE:Site FAT","SITE:Remote Implementation","SITE:Commissioning","SITE:Site Engineering",
    "SU:Demand Service","SU:Commissioning Travel","SU:Comp. Time"]], ["T", [
    "TECH:Time Sheets","TECH:Microsoft Certification","TECH:BOM PO Amendments","TECH:Expense Sheets","TECH:Business Reporting",
    "TECH:BOM System","TECH:Bill Pay System","TECH:Branded Products","TECH:Work Products","TRAV:Project Other Travel",
    "TRAV:Project Startup Travel","TRAV:Sales and Other Travel","TRAV:Other Travel"]], ["W",["WAR:Project Warranty","WAR:Tech Support"]] ]
    
    static let organizedSprintNames = [["B", ["Base HMI","Base PLC Project","Base Project","Batching","Blank"]],
        ["C", ["CIP"]], ["E", ["EE"]], ["F", ["Functional Specification"]], ["I", ["I/O Map"]], ["P", ["Pasteurizer", "Purchase requisitions"]],
        ["R", ["Receiving","Routing"]],[ "S", ["Storage"]] ]
    
    
    static var projectNames:[String]
    {
        get
        {
            var projectNames = [String]()
            for letter in Constants.organizedProjectNames
            {
                let arrayForLetter = organizedProjectNames[Constants.organizedProjectNames.indexOf(letter)!][1] as! [String]
                
                for string:String in arrayForLetter
                {
                    projectNames.append(string)
                }
            }
            
            return projectNames
        }
    }
    
    static var taskCodeNames:[String]
    {
        get
        {
            var taskCodeNames = [String]()
            for letter in Constants.organizedTaskCodeNames
            {
                let arrayForLetter = organizedTaskCodeNames[Constants.organizedTaskCodeNames.indexOf(letter)!][1] as! [String]
                
                for string:String in arrayForLetter
                {
                    taskCodeNames.append(string)
                }
            }
            
            return taskCodeNames
        }
    }
    
    static var sprintNames:[String]
    {
        get
        {
        var sprintNames = [String]()
        for letter in Constants.organizedSprintNames
        {
            let arrayForLetter = organizedSprintNames[Constants.organizedSprintNames.indexOf(letter)!][1] as! [String]
            
            for string:String in arrayForLetter
            {
                sprintNames.append(string)
            }
        }
        
        return sprintNames
        }
    }
}