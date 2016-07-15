//
//  AppDelegate.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/8/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window!.tintColor = UIColor(red: 0.38, green: 0.663, blue: 0.867, alpha: 1)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        print("Hello")
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("Hello")
        
        let opportunityNames = ["Cats", "Realm", "Cleaning"]
        
        for opportunity in opportunityNames {
            RealmPopulator.addOpportunity(withOppName: opportunity)
            print("Added opportunity: \(opportunity)")
        }
        
        let categories = ["Books", "Movies", "Music"]
        
        for category in categories {
            RealmPopulator.addSprintCategory(withSprintName: category)
            print("Added opportunity: \(category)")
        }
        
        let taskcodes = ["one", "two", "three"]
        
        for code in taskcodes {
            RealmPopulator.addTaskcode(withTaskcodeName: code)
            print("Added taskcode \(code)")
        }
        
        let names = RealmQuery.fetchOpportunities(1)
        let firstName = names.first!.name
        print("The first opportunity is : \(firstName)")
        
        let cat = RealmQuery.fetchSpringCategories(2).first!.name
        print("The second sprint category is \(cat)")
        
        let codes = RealmQuery.fetchTaskcodes(3).first!.name
        print("The third task code is \(codes)")

//        // Adding a timesheet
//        RealmPopulator.addTimeSheet()
//        let opp = Opportunity()
//        opp.name = "Project"
//        
//        print("Made opportunity: \(opp.name)")
//        
//        let sprintCat = SprintCategory()
//        sprintCat.name = "Sprint"
//        print("Made Sprint Category: \(sprintCat.name)")
//        
//        let code = Taskcode()
//        code.name = "Whatever"
//        print("Made Task Code: \(code.name)")
//        
//        RealmPopulator.addTimeSheet()
//        
//        let timesheet = RealmQuery.fetchTimesheets(1)
//        if let firstTimesheet = timesheet.first {
//            RealmPopulator.addTimesheetDetailEntry(withOpportunity: opp, withSprintCategory: sprintCat, withTaskCode: code, withTimesheet: firstTimesheet)
//            print("Successfully added TimeSheetDetailEntry!!!")
//        }
        
        
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

