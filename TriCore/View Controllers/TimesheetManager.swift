//
//  TimesheetManager.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/27/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class TimesheetManager: UIViewController
{
    let pager:PagesController = PagesController()
    var leftArrow:UIButton?
    var rightArrow:UIButton?
    let blackness:UIView = UIView()
    var timesheetController:TimesheetsViewController?
    var timesheets:[TimesheetsViewController] = [TimesheetsViewController]()
    
    override func viewDidLoad()
    {
        self.pager.startPage = 2

        
        setupTimeSheetChangerViews()
        
        self.blackness.frame = CGRectMake(0, 0, self.view.frame.width,
            self.navigationController!.view.frame.height + self.view.frame.height)
        self.blackness.backgroundColor = UIColor.blackColor()
        self.navigationController!.view.addSubview(blackness)
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let timesheet1 = self.storyboard!.instantiateViewControllerWithIdentifier("Timesheet") as! TimesheetsViewController
        let timesheet2 = self.storyboard!.instantiateViewControllerWithIdentifier("Timesheet") as! TimesheetsViewController
        let timesheet3 = self.storyboard!.instantiateViewControllerWithIdentifier("Timesheet") as! TimesheetsViewController
        
        self.timesheets = [timesheet1, timesheet2, timesheet3]
        
        for timesheet in self.timesheets
        {
            timesheet.navCont = self.navigationController
            timesheet.manager = self
        }
        
        self.pager.add(self.timesheets)
        self.pager.goTo((self.pager.pages.count - 1))
        
        self.pager.enableSwipe = false
        self.pager.view.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(self.pager.view)

        self.addChildViewController(self.pager)
        self.checkArrows()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let publishButton = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "publishTimesheet")
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showAddRowForm")
        
        self.tabBarController!.navigationItem.leftBarButtonItem = publishButton
        self.tabBarController!.navigationItem.rightBarButtonItem = plusButton
        
        self.tabBarController!.navigationItem.title = ""
        
        self.leftArrow!.hidden = false
        self.rightArrow!.hidden = false
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
    override func viewWillDisappear(animated: Bool) {
        self.leftArrow!.hidden = true
        self.rightArrow!.hidden = true
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
        
        self.navigationController!.view.addSubview(timesheetDateLabel)
        
        self.leftArrow = UIButton(frame: CGRectMake(timesheetDateLabel.frame.origin.x - 40 - 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            40, 40))
        
        self.rightArrow = UIButton(frame: CGRectMake(CGRectGetMaxX(timesheetDateLabel.frame) + 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            40, 40))
        
        self.leftArrow!.addTarget(self, action: "leftTimesheetRequested", forControlEvents: UIControlEvents.TouchUpInside)
        self.rightArrow!.addTarget(self, action: "rightTimesheetRequested", forControlEvents: UIControlEvents.TouchUpInside)
        
        var arrowImage = UIImage(named:"Right Arrow")
        arrowImage = arrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.leftArrow!.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        self.leftArrow!.tintColor = UIColor.whiteColor()
        self.rightArrow!.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        self.rightArrow!.tintColor = UIColor.whiteColor()
        self.leftArrow!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
//        self.rightArrow!.enabled = false
        
        self.navigationController!.view.addSubview(self.leftArrow!)
        self.navigationController!.view.addSubview(self.rightArrow!)
    }
    
    // MARK: Timesheet Handling
    
    func publishTimesheet()
    {
        let currentSheet:TimesheetsViewController = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        currentSheet.publishTimesheet()
    }
    
    func unPublishTimesheet()
    {
        let currentSheet:TimesheetsViewController = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        currentSheet.unPublishTimesheet()
        
        self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "publishTimesheet")
    }
    
    func publishedTimesheet()
    {
        self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Un-Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "unPublishTimesheet")
    }
    
    func leftTimesheetRequested()
    {
        self.pager.previous()
        
        self.checkPublishedButtons()
        self.checkArrows()
    }
    
    func rightTimesheetRequested()
    {
        self.pager.next()
        
        self.checkPublishedButtons()
        self.checkArrows()
    }
    
    func checkPublishedButtons()
    {
        let currentTimesheet = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        if currentTimesheet.publishedSheet == true
        {
            self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Un-Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "unPublishTimesheet")
        } else
        {
            self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "publishTimesheet")
        }
    }
    
    func checkArrows()
    {
        if self.pager.currentIndex == 0
        {
            self.leftArrow!.enabled = false
            self.rightArrow!.enabled = true
        } else if self.pager.currentIndex == (self.pager.pages.count - 1)
        {
            self.rightArrow!.enabled = false
            self.leftArrow!.enabled = true
        } else
        {
            self.leftArrow!.enabled = true
            self.rightArrow!.enabled = true
        }
    }
    
    // MARK: Navigation
    
    func showAddRowForm()
    {
        self.timesheetController!.showAddRowForm()
    }
    
}
