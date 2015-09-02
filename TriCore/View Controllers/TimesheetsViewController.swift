//
//  TimesheetsViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/10/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class TimesheetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchResultsUpdating
{
    // MARK: Properties
    @IBOutlet weak var projectsTable: UITableView!
    var projectList:[[String:AnyObject]] = GetProjectList.getOrganizedProjectList()
    var unorganizedList:[TimesheetEntry] = []
    var filteredList:[TimesheetEntry] = [TimesheetEntry]()
    
    var currentTextField:UITextField?
    var currentCell:ProjectTableViewCell?
    var keyboardHeight:CGFloat?
    var distanceMoved:CGFloat?
    
    var entryAdded:Bool = false
    var entryAddedAt:[Int]?
    var navCont:UINavigationController?
    var manager:TimesheetManager?
    var publishedSheet:Bool = false
    var overlay:PublishedOverlay?
    
    var searchCont:UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        self.projectsTable.delegate = self
        self.projectsTable.dataSource = self
        
        self.definesPresentationContext = true
        self.searchCont.searchResultsUpdater = self
        self.searchCont.searchBar.sizeToFit()
        self.searchCont.dimsBackgroundDuringPresentation = false
        
        self.unorganizedList = GetProjectList.getUnorganizedProjectList(withOrganizedList: projectList)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldPressed:", name: UIKeyboardWillShowNotification, object: nil)
        
        if self.publishedSheet
        {
            self.view.addSubview(self.overlay!)
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if self.publishedSheet
        {
            self.overlay!.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if self.entryAdded
        {
            self.entryAdded = false
            
            self.projectsTable.scrollToRowAtIndexPath(NSIndexPath(forRow: entryAddedAt![1], inSection: entryAddedAt![0]), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            
            self.makeCellGlow()
        }
        
        if self.publishedSheet
        {
            self.view.addSubview(self.overlay!)
            PublishedOverlay.showCompleted()
        }
        
        self.projectsTable.tableHeaderView = self.searchCont.searchBar
    }
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId:String = "ProjectCell"
        
        let cell:ProjectTableViewCell = self.projectsTable.dequeueReusableCellWithIdentifier(cellId) as! ProjectTableViewCell
        
        var entry:TimesheetEntry
        
        if self.searchCont.active
        {
            entry = self.filteredList[indexPath.row]
        } else
        {
            let dictionary = projectList[indexPath.section]
            let entriesForSection = dictionary["Entries"] as! [TimesheetEntry]
            entry = entriesForSection[indexPath.row] as TimesheetEntry
        }
        
        cell.projectTitleAndNumber.text = entry.projectName
        cell.taskCodeName.text = entry.taskCode
        cell.sprintCategoryName.text = entry.sprintCategory!
        cell.controller = self
        
        for textField in cell.textFields!
        {
            textField.delegate = self
        }
    
        cell.indexPath = indexPath
        
        cell.setupWithHours(hours: entry.hours)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if self.searchCont.active == false
        {
            var array = (self.projectList[indexPath.section]["Entries"] as![TimesheetEntry])
            array.removeAtIndex(indexPath.row)
            self.projectList[indexPath.section]["Entries"] = array
            self.projectsTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            if (self.projectList[indexPath.section]["Entries"] as! [TimesheetEntry]).count == 0
            {
                self.projectList.removeAtIndex(indexPath.section)
                self.projectsTable.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            print(self.projectList)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.searchCont.active
        {
            return self.filteredList.count
        } else
        {
            return (projectList[section]["Entries"] as! [TimesheetEntry]).count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if self.searchCont.active
        {
            return 1
        } else
        {
            return projectList.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if self.searchCont.active
        {
            return nil
        } else
        {
            let letter = self.projectList[section]["Letter"] as! String
            return letter
        }
    }
    
    // MARK: TextField Methods
    func textFieldPressed(sender:NSNotification)
    {
        let userInfo = sender.userInfo
        
        if let userInfo = userInfo
        {
            if self.searchCont.searchBar.isFirstResponder() == false
            {
                let keyboardRect = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue
                self.keyboardHeight = self.view.frame.height - keyboardRect.height
                
                let rectOfCellInTableView = self.projectsTable.rectForRowAtIndexPath(self.currentCell!.indexPath!)
                let rectOfCellInSuperview = self.projectsTable.convertRect(rectOfCellInTableView, toView: self.projectsTable.superview)
                let topOfTabBar = self.tabBarController!.tabBar.frame.origin.y
                let bottomOfCell = rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height
                let distanceBetween = topOfTabBar - bottomOfCell
                
//                drawLineAt(y: self.keyboardHeight!)
//                drawLineAt(y: rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height)
                
                if rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height > self.keyboardHeight
                {
                    if self.distanceMoved > 0
                    {
                        self.animateTextField(distance: self.distanceMoved!, andUp: false)
                        let rectOfCellInTableView = self.projectsTable.rectForRowAtIndexPath(self.currentCell!.indexPath!)
                        let rectOfCellInSuperview = self.projectsTable.convertRect(rectOfCellInTableView, toView: self.projectsTable.superview)
                        self.distanceMoved = (bottomOfCell - self.keyboardHeight! - self.searchCont.searchBar.frame.height - 5)
                        self.animateTextField(distance: self.distanceMoved!, andUp: true)
                    } else
                    {
                        self.distanceMoved = (bottomOfCell - self.keyboardHeight! - self.searchCont.searchBar.frame.height - 5)
                        self.animateTextField(distance: self.distanceMoved!, andUp: true)
                    }
                }
            }
        }
    }
    
    func drawLineAt(y y:CGFloat)
    {
        let line = UIView(frame: CGRectMake(0, y, self.view.frame.width, 2))
        line.backgroundColor = UIColor.redColor()
        self.view.addSubview(line)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.currentTextField = textField
        self.currentCell = textField.superview as? ProjectTableViewCell
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
//        self.animateTextField(withTextField: textField, andUp: false)
    }
    
    func animateTextField(distance distance:CGFloat, andUp up:Bool)
    {
        let movementDistance:CGFloat = distance * -1
        let movementDuration = 0.3
        
        let movement:CGFloat = up ? movementDistance: -movementDistance
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    func didTapDone(sender: AnyObject?) {
        self.currentTextField!.resignFirstResponder()
        
        if let _ = self.distanceMoved
        {
            self.animateTextField(distance: self.distanceMoved!, andUp: false)
        }
        
        self.distanceMoved = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if let _ = self.distanceMoved
        {
            self.animateTextField(distance: self.distanceMoved!, andUp: false)
        }
        
        self.distanceMoved = nil
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        
        if newLength == 0
        {
            textField.font = UIFont.systemFontOfSize(18)
        } else if newLength > 0
        {
            textField.font = UIFont.boldSystemFontOfSize(20)
        }
        
        if newLength <= 2
        {
            self.logNewHours(withText: textField.text! + string)
            return true
        } else
        {
            return false
        }
    }
    
    func logNewHours(withText text:String)
    {
        let intValue = Int(text)
        
        var currentTextFieldIndex:Int = -1
        
        for textField in self.currentCell!.textFields!
        {
            if self.currentTextField == textField
            {
                currentTextFieldIndex = self.currentCell!.textFields!.indexOf(textField)!
            }
        }
        
        (self.projectList[currentCell!.indexPath!.section]["Entries"] as! [TimesheetEntry])[currentCell!.indexPath!.row].hours[currentTextFieldIndex] = intValue
    }
    
    func hitRightButton()
    {
        hitArrowButtonRight(yes: true)
    }
    
    func hitLeftButton()
    {
        hitArrowButtonRight(yes: false)
    }
    
    func hitArrowButtonRight(yes bool:Bool)
    {
        var currentTextFieldIndex:Int = -1
        
        for textField in self.currentCell!.textFields!
        {
            if self.currentTextField == textField
            {
                currentTextFieldIndex = self.currentCell!.textFields!.indexOf(textField)!
            }
        }
        
        if bool == true
        {
            currentTextFieldIndex += 1
        } else
        {
            currentTextFieldIndex -= 1
        }
        
        if currentTextFieldIndex > 6
        {
            currentTextFieldIndex = 0
        } else if currentTextFieldIndex < 0
        {
            currentTextFieldIndex = 6
        }
        
        self.currentTextField = self.currentCell!.textFields![currentTextFieldIndex]
        self.currentTextField!.becomeFirstResponder()
    }
    
    // MARK: Entry Handling
    func newEntryCreated(withEntry entry:TimesheetEntry)
    {
        let atSection = self.addEntryToProjectList(withEntry: entry)
        
        var row:Int
        
        if let _ = self.projectList[atSection]["Entries"] as? [TimesheetEntry]
        {
            row = (self.projectList[atSection]["Entries"] as! [TimesheetEntry]).count - 1
        } else
        {
            row = 0
        }
        
        self.entryAdded = true
        self.entryAddedAt = [atSection, row]
        
        self.projectsTable.reloadData()
    }
    
    func addEntryToProjectList(withEntry entry:TimesheetEntry) -> Int
    {
        let firstLetter = GetProjectList.findFirstLetter(inString: entry.projectName)
        let letterNum = GetProjectList.letterList.indexOf(firstLetter)
        
        var index = -1
        
        if self.projectList.count < 1
        {
            let letter = GetProjectList.findFirstLetter(inString: entry.projectName)
            let newDictionary = ["Letter":letter,"Entries":[entry]]
            self.projectList.append(newDictionary as! [String : AnyObject])
            print("SHould append \(self.projectList)")
        } else
        {
            for var i = 0; i < self.projectList.count; i++
            {
                let dict = self.projectList[i]
                let letter = dict["Letter"] as! String
                
                let otherNum = GetProjectList.letterList.indexOf(letter)
                index = i
                
                if otherNum == letterNum
                {
                    var entryArray = self.projectList[index]["Entries"] as! [TimesheetEntry]
                    entryArray.append(entry)
                    self.projectList[index]["Entries"] = entryArray
                    print("This")
                    return index
                    
                } else if letterNum < otherNum
                {
                    print("Or this")
                    index = i--
                    let newDictionary = ["Letter":firstLetter,"Entries":[entry]]
                    self.projectList.insert(newDictionary as! [String : AnyObject], atIndex: index)
                    return index
                } else if index == self.projectList.count - 1
                {
                    index++
                    let newDictionary = ["Letter":firstLetter,"Entries":[entry]]
                    self.projectList.insert(newDictionary as! [String : AnyObject], atIndex: index)
                    return index
                }
            }
        }
        
        self.unorganizedList = GetProjectList.getUnorganizedProjectList(withOrganizedList: self.projectList)
        
        return 0
    }
    
    func makeCellGlow()
    {
        
    }
    
    // MARK: Publishing
    func publishTimesheet()
    {
        self.overlay = PublishedOverlay()
        overlay!.frame = CGRectMake(self.view.frame.origin.x, self.projectsTable.frame.origin.y, self.view.frame.width, self.projectsTable.frame.height)

        self.view.addSubview(overlay!)

        PublishedOverlay.showPublishing()

        let queue = NSOperationQueue()

        queue.addOperationWithBlock { () -> Void in
            let result = TimesheetPublisher.publishTimesheet(withHours: nil)

            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.givePublishedAnimation()
            })
        }
    }
    
    func unPublishTimesheet()
    {
        self.overlay!.removeFromSuperview()
        self.publishedSheet = false
    }
    
    func givePublishedAnimation()
    {
        PublishedOverlay.showCompleted()
        
        self.manager!.publishedTimesheet()
        self.publishedSheet = true
    }
    
    // MARK: Navigation
    
    func showAddRowForm()
    {
        self.performSegueWithIdentifier("showAddRowForm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddRowForm"
        {
            let navController = segue.destinationViewController as! UINavigationController
            let createController = navController.viewControllers.first as! AddRowFormController
            createController.timesheetController = self
        }
    }
    
    // MARK: Searching
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredList.removeAll(keepCapacity: false)
        
        let searchText = self.searchCont.searchBar.text
        let strippedText = searchText!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as NSString
        
        var searchItems = [String]()
        
        if strippedText.length > 0
        {
            searchItems = strippedText.componentsSeparatedByString(" ")
        }
        
        var andMatchPredicates = [NSCompoundPredicate]()
        
        for searchItem in searchItems
        {
            var searchPredicates = [NSPredicate]()
            
            var lhs = NSExpression(forKeyPath: "projectName")
            var rhs = NSExpression(forConstantValue: searchItem)
            var predicate:NSPredicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier:NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.ContainsPredicateOperatorType, options: NSComparisonPredicateOptions.CaseInsensitivePredicateOption)
            
            searchPredicates.append(predicate)
            
            lhs = NSExpression(forKeyPath: "taskCode")
            rhs = NSExpression(forConstantValue: searchItem)
            predicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier:NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.ContainsPredicateOperatorType, options: NSComparisonPredicateOptions.CaseInsensitivePredicateOption)
            
            searchPredicates.append(predicate)
            
            lhs = NSExpression(forKeyPath: "sprintCategory")
            rhs = NSExpression(forConstantValue: searchItem)
            predicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier:NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.ContainsPredicateOperatorType, options: NSComparisonPredicateOptions.CaseInsensitivePredicateOption)
            
            searchPredicates.append(predicate)
            
            let orMatchPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: searchPredicates)
            
            andMatchPredicates.append(orMatchPredicates)
        }
        
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let list:[TimesheetEntry] = (self.unorganizedList as NSArray).filteredArrayUsingPredicate(finalCompoundPredicate) as! [TimesheetEntry]
        
        self.filteredList = list
        self.projectsTable.reloadData()
    }
    
}
