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
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    let pager:PagesController = PagesController()
    var leftArrow:UIButton?
    var rightArrow:UIButton?
    let blackness:UIView = UIView()
    var timesheetController:TimesheetViewController?
    var timesheets:[TimesheetViewController] = [TimesheetViewController]()
    var containerRect:CGRect?
    var containerView:UIView?
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
    override func viewDidLoad()
    {
        self.pager.startPage = 2
        
        self.blackness.frame = CGRectMake(0, 0, self.view.frame.width,
            self.navigationController!.view.frame.height + self.view.frame.height)
        self.blackness.backgroundColor = UIColor.blackColor()
        self.navigationController!.view.addSubview(blackness)
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let timesheet1 = self.storyboard!.instantiateViewControllerWithIdentifier("TimesheetVIewController") as! TimesheetViewController
        let timesheet2 = self.storyboard!.instantiateViewControllerWithIdentifier("TimesheetVIewController") as! TimesheetViewController
        let timesheet3 = self.storyboard!.instantiateViewControllerWithIdentifier("TimesheetVIewController") as! TimesheetViewController
        
        self.timesheets = [timesheet1, timesheet2, timesheet3]
        
        for timesheet in self.timesheets
        {
            timesheet.navCont = self.navigationController
            timesheet.manager = self
        }
        
        self.containerRect = CGRectMake(0, self.navigationController!.navigationBar.frame.height + statusBarHeight(), self.view.frame.width, self.view.frame.height - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height - statusBarHeight())
        
        self.pager.add(self.timesheets)
        self.pager.goTo((self.pager.pages.count - 1))
        
        self.pager.enableSwipe = false
        self.pager.view.frame = self.containerRect!
        
        self.view.addSubview(self.pager.view)
        
        self.addChildViewController(self.pager)
        
        let statusBar = UIToolbar(frame: CGRectMake(0, -20, self.view.frame.width , 20))
        
        statusBar.backgroundColor = self.navBar.barTintColor
        statusBar.barTintColor = self.navBar.barTintColor
        self.navBar.addSubview(statusBar)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        setupTimeSheetChangerViews()
        
        self.checkArrows()
        self.navigationController!.navigationBarHidden = true
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        if let _ = blackness.superview
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
        self.leftArrow = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 51, 3, 40, 40))
        
        self.rightArrow = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) + 11, 3, 40, 40))

        
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
        
        self.navBar.addSubview(self.leftArrow!)
        self.navBar.addSubview(self.rightArrow!)
    }
    
    // MARK: Timesheet Handling
    
    @IBAction func publishTimesheet(sender: AnyObject)
    {
        self.publishTimesheet()
    }
    
    func publishTimesheet()
    {
        let currentSheet:TimesheetsViewController = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        currentSheet.publishTimesheet()
    }
    
    func unPublishTimesheet()
    {
        let currentSheet:TimesheetsViewController = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        currentSheet.unPublishTimesheet()
        
        self.publishButton.title = "Publish"
        self.publishButton.action =  "publishTimesheet"
    }
    
    func publishedTimesheet()
    {
        self.publishButton.title = "Un-Publish"
        self.publishButton.action =  "unPublishTimesheet"
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
            self.publishButton.title = "Un-Publish"
            self.publishButton.action =  "unPublishTimesheet"
        } else
        {
            self.publishButton.title = "Publish"
            self.publishButton.action =  "publishTimesheet"
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
    @IBAction func showAddRowForm(sender: AnyObject)
    {
        let currentTimesheet = self.pager.pages[self.pager.currentIndex] as! TimesheetsViewController
        currentTimesheet.showAddRowForm()
    }
    
}
