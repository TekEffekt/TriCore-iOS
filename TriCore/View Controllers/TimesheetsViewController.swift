//
//  TimesheetsViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/10/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class TimesheetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate
{
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var projectsTable: UITableView!
    var projectList:[[String:AnyObject]] = GetProjectList.getOrganizedProjectList()
    
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
    
    var hours:[[[Int?]]] = []
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        self.projectsTable.delegate = self
        self.projectsTable.dataSource = self
        self.searchBar.delegate = self
        
        setupHoursArray()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldPressed:", name: UIKeyboardWillShowNotification, object: nil)
        if self.publishedSheet
        {
            self.overlay!.hidden = false
            
            self.view.addSubview(self.overlay!)
            PublishedOverlay.showCompleted()
        }
    }
    
    
    override func viewDidDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.publishedSheet
        {
            self.overlay!.removeFromSuperview()
        }
    }
    
    func setupHoursArray()
    {
        for section in 0..<projectList.count
        {
            self.hours.append([[Int?]]())
            for row in 0..<(projectList[section]["Entries"] as! [TimesheetEntry]).count
            {
                self.hours[section].append([Int?]())
                for i in 1...7
                {
                    self.hours[section][row].append(nil)
                }
            }
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
    }
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId:String = "ProjectCell"
        
        let cell:ProjectTableViewCell = self.projectsTable.dequeueReusableCellWithIdentifier(cellId) as! ProjectTableViewCell
        
        let dictionary = projectList[indexPath.section]
        let entriesForSection = dictionary["Entries"] as! [TimesheetEntry]
        let entry = entriesForSection[indexPath.row] as TimesheetEntry
        
        cell.projectTitleAndNumber.text = entry.projectName
        cell.taskCodeName.text = entry.taskCode
        cell.sprintCategoryName.text = entry.sprintCategory!
        cell.controller = self
        
        for textField in cell.textFields!
        {
            textField.delegate = self
        }
    
        cell.indexPath = indexPath
        
        cell.setupWithHours(hours: self.hours[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (projectList[section]["Entries"] as! [TimesheetEntry]).count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return projectList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let letter = self.projectList[section]["Letter"] as! String
        return letter
    }
    
    // MARK: TextField Methods
    func textFieldPressed(sender:NSNotification)
    {
        let userInfo = sender.userInfo
        
        if let userInfo = userInfo
        {
            let keyboardRect = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue
            self.keyboardHeight = self.view.frame.height - keyboardRect.height
            
            let rectOfCellInTableView = self.projectsTable.rectForRowAtIndexPath(self.currentCell!.indexPath!)
            let rectOfCellInSuperview = self.projectsTable.convertRect(rectOfCellInTableView, toView: self.projectsTable.superview)
            
            if rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height > self.keyboardHeight
            {
                if self.distanceMoved > 0
                {
                    self.animateTextField(distance: self.distanceMoved!, andUp: false)
                    let rectOfCellInTableView = self.projectsTable.rectForRowAtIndexPath(self.currentCell!.indexPath!)
                    let rectOfCellInSuperview = self.projectsTable.convertRect(rectOfCellInTableView, toView: self.projectsTable.superview)
                    self.distanceMoved = (rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height) - self.keyboardHeight!
                    self.animateTextField(distance: self.distanceMoved!, andUp: true)
                } else
                {
                    self.distanceMoved = (rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height) - self.keyboardHeight!
                    self.animateTextField(distance: self.distanceMoved!, andUp: true)
                }
            }
        }
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
        
        self.hours[self.currentCell!.indexPath!.section][self.currentCell!.indexPath!.row][currentTextFieldIndex] = intValue!
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
        
        self.hours[atSection!].append([Int?]())
        
        for i in 1...7
        {
            self.hours[atSection!][self.hours[atSection!].count-1].append(nil)
        }
        
        let row = self.hours[atSection!].count-1
        
        self.entryAdded = true
        self.entryAddedAt = [atSection!, row]
        
        self.projectsTable.reloadData()
    }
    
    func addEntryToProjectList(withEntry entry:TimesheetEntry) -> Int?
    {
        let firstLetter = GetProjectList.findFirstLetter(inString: entry.projectName)
        let letterNum = GetProjectList.letterList.indexOf(firstLetter)
        
        print("First Letter \(firstLetter)")
        
        var index = -1
        
        for var i = 0; i < self.projectList.count; i++
        {
            let dict = self.projectList[i]
            let letter = dict["Letter"] as! String
            let otherNum = GetProjectList.letterList.indexOf(letter)
            
            if otherNum == letterNum
            {
                index = i
                var entryArray = self.projectList[index]["Entries"] as! [TimesheetEntry]
                entryArray.append(entry)
                self.projectList[index]["Entries"] = entryArray
                return index
                
            } else if letterNum < otherNum
            {
                index = i--
                let newDictionary = ["Letter":firstLetter,"Entries":[entry]] 
                self.projectList.insert(newDictionary as! [String : AnyObject], atIndex: index)
                return index
            }
        }
        
        return nil
    }
    
    func makeCellGlow()
    {
        
    }
    
    // MARK: Publishing
    func publishTimesheet()
    {
        self.overlay = PublishedOverlay()
        overlay!.frame = CGRectMake(self.view.frame.origin.x, self.searchBar.frame.origin.y-8, self.view.frame.width, self.searchBar.frame.height + self.projectsTable.frame.height + 16)

        self.view.addSubview(overlay!)

        PublishedOverlay.showPublishing()

        let queue = NSOperationQueue()

        queue.addOperationWithBlock { () -> Void in
            let result = TimesheetPublisher.publishTimesheet(withHours: self.hours)

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
    
}
