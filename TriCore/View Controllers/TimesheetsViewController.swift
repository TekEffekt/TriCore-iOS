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
    
    var currentTextField:UITextField?
    var currentCell:ProjectTableViewCell?
    
    // MARK: Initialization
    override func viewDidLoad()
    {

        setupTimeSheetChangerViews()
        
        print("setup problem")
        
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
        
        var arrowImage = UIImage(named:"Right Arrow")
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
    
    func setupTextField(withContainer container:UIView, andIndex index:Int) -> JVFloatLabeledTextField
    {
        let textField = JVFloatLabeledTextField(frame: container.frame)
        textField.attributedPlaceholder = NSAttributedString(string: Constants.weekNameStrings[index],
            attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor().colorWithAlphaComponent(0.8)])
        textField.floatingLabelTextColor = UIColor.darkGrayColor()
        textField.font = UIFont.systemFontOfSize(15)
        textField.floatingLabelFont = UIFont.systemFontOfSize(13)
        textField.center = container.center
        textField.backgroundColor = UIColor(red:0.97, green:0.59, blue:0.11, alpha:1.0).colorWithAlphaComponent(0.2)
        textField.textAlignment = NSTextAlignment.Center
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.Done
        addButtonsTo(textField)
        
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.blackColor().CGColor
        textField.layer.borderWidth = 1.0
        
        return textField
    }
    
    // MARK: TableView Datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId:String = "ProjectCell"
        
        let cell:ProjectTableViewCell = self.projectsTable.dequeueReusableCellWithIdentifier(cellId) as! ProjectTableViewCell
        
        let text = projectList[indexPath.section][indexPath.row]
        cell.projectTitleAndNumber.text = text.componentsSeparatedByString(";")[0]
        
        cell.textFields = []
        
        if cell.subviews.count < 8
        {
            for container in cell.textFieldContainerCollection
            {
                let index =  cell.textFieldContainerCollection.indexOf(container)
                let textField = setupTextField(withContainer: container, andIndex: index!)
                cell.textFields!.append(textField)
                cell.addSubview(textField)
                container.backgroundColor = UIColor.clearColor()
            }
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField
        self.currentCell = textField.superview as? ProjectTableViewCell
    }
    
    private func addButtonsTo(textField: UITextField) {
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "didTapDone:")
        
        var rightArrowImage = UIImage(named:"Right Arrow")
        rightArrowImage = rightArrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        var leftArrowImage = UIImage(named:"Left Arrow")
        leftArrowImage = leftArrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let leftArrowButton = UIBarButtonItem(image: leftArrowImage,
            style: UIBarButtonItemStyle.Bordered, target: self, action: "hitLeftButton")
        let rightArrowButton = UIBarButtonItem(image: rightArrowImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "hitRightButton")
                
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.tintColor = self.view.tintColor
        keyboardToolbar.sizeToFit()
        keyboardToolbar.items = [leftArrowButton, rightArrowButton, flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
    }
    
    func didTapDone(sender: AnyObject?) {
        self.currentTextField!.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        
        if newLength == 0
        {
            textField.font = UIFont.systemFontOfSize(20)
        } else if newLength > 0
        {
            textField.font = UIFont.boldSystemFontOfSize(22)
        }
        
        return newLength <= 2
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
}
