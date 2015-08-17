//
//  TimesheetsViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/10/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class TimesheetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    // MARK: Properties
    let blackness:UIView = UIView()
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var projectsTable: UITableView!
    let projectList = GetProjectList.getProjectList()
    
    var leftArrow:UIButton?
    var rightArrow:UIButton?
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        setupTimeSheetChangerViews()
        
        self.blackness.frame = CGRectMake(0, 0, self.view.frame.width,
            self.navigationController!.view.frame.height + self.view.frame.height)
        self.blackness.backgroundColor = UIColor.blackColor()
        self.navigationController!.view.addSubview(blackness)
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.projectsTable.delegate = self
        self.projectsTable.dataSource = self
        self.searchBox.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldPressed:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let publishButton = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "doStuff")
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "doStuff")
        
        self.tabBarController!.navigationItem.leftBarButtonItem = publishButton
        self.tabBarController!.navigationItem.rightBarButtonItem = plusButton
        
        self.leftArrow!.hidden = false
        self.rightArrow!.hidden = false
        
        self.tabBarController!.navigationItem.title = ""
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.leftArrow!.hidden = true
        self.rightArrow!.hidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if let superview = blackness.superview
        {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.blackness.alpha = 0.0
                }) { (Bool) -> Void in
                    self.blackness.removeFromSuperview()
            }
        }
    }

    func setupTimeSheetChangerViews()
    {
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        
        let timesheetDate:String = ""
        let timesheetDateLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 15, navBarHeight))
        timesheetDateLabel.text = timesheetDate
        timesheetDateLabel.textAlignment = NSTextAlignment.Center
        timesheetDateLabel.textColor = UIColor.whiteColor()
        timesheetDateLabel.font = timesheetDateLabel.font.fontWithSize(self.view.frame.width/16)
        timesheetDateLabel.center = self.tabBarController!.navigationController!.navigationBar.center
        print(self.view.frame.width/17)
        
        self.navigationController!.view.addSubview(timesheetDateLabel)
        
        self.leftArrow = UIButton(frame: CGRectMake(timesheetDateLabel.frame.origin.x - 40 - 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            40, 40))

        self.rightArrow = UIButton(frame: CGRectMake(CGRectGetMaxX(timesheetDateLabel.frame) + 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            40, 40))
        
        var arrowImage = UIImage(named:"Arrow")
        arrowImage = arrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.leftArrow!.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        self.leftArrow!.tintColor = UIColor.whiteColor()
        self.rightArrow!.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        self.rightArrow!.tintColor = UIColor.whiteColor()
        self.leftArrow!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.rightArrow!.enabled = false

        self.navigationController!.view.addSubview(self.leftArrow!)
        self.navigationController!.view.addSubview(self.rightArrow!)
    }
    
    func doStuff()
    {
        print("Hit!")
    }
    
    func setupTextField(withContainer container:UIView) -> JVFloatLabeledTextField
    {
        let textField = JVFloatLabeledTextField(frame: container.frame)
        textField.attributedPlaceholder = NSAttributedString(string: "Fri", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor().colorWithAlphaComponent(0.8)])
        textField.floatingLabelTextColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.9)
        textField.font = UIFont.boldSystemFontOfSize(22)
        textField.floatingLabelFont = UIFont.systemFontOfSize(13)
        textField.center = container.center
        textField.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        textField.textAlignment = NSTextAlignment.Center
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.delegate = self
        
        return textField
    }
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId:String = "ProjectCell"
        
        let cell:ProjectTableViewCell = self.projectsTable.dequeueReusableCellWithIdentifier(cellId) as! ProjectTableViewCell
        
        let text = projectList[indexPath.section][indexPath.row]
        cell.projectTitleAndNumber.text = text.componentsSeparatedByString(";")[0]
        
        for container in cell.textFieldContainerCollection
        {
            let textField = setupTextField(withContainer: container)
            cell.addSubview(textField)
            container.backgroundColor = UIColor.clearColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return projectList[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return projectList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let projectName = self.projectList[section][0]
        let projectFirstLetter = projectName[projectName.startIndex]
        
        return String(projectFirstLetter)
    }
    
    // MARK: TextField Methods
    func textFieldPressed(sender:NSNotification)
    {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        return newLength < 2
    }
    
}