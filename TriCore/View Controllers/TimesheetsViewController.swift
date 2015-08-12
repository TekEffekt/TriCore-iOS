//
//  TimesheetsViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/10/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class TimesheetsViewController: UIViewController
{
    // MARK: Properties
    let blackness:UIView = UIView()
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        setupTimeSheetChangerViews()
        
        self.blackness.frame = CGRectMake(0, 0, self.view.frame.width,
            self.navigationController!.view.frame.height + self.view.frame.height)
        self.blackness.backgroundColor = UIColor.blackColor()
        self.navigationController!.view.addSubview(blackness)
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let publishButton = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Plain, target: self, action: "doStuff")
        let plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "doStuff")

        self.tabBarController!.navigationItem.leftBarButtonItem = publishButton
        self.tabBarController!.navigationItem.rightBarButtonItem = plusButton
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
        let timesheetDateLabel:UILabel = UILabel(frame: CGRectMake(0, 0, 10, navBarHeight))
        timesheetDateLabel.text = timesheetDate
        timesheetDateLabel.textAlignment = NSTextAlignment.Center
        timesheetDateLabel.textColor = UIColor.whiteColor()
        timesheetDateLabel.font = timesheetDateLabel.font.fontWithSize(self.view.frame.width/16)
//        timesheetDateLabel.backgroundColor = UIColor.redColor()
        timesheetDateLabel.center = self.tabBarController!.navigationController!.navigationBar.center
        print(self.view.frame.width/17)
        
        self.navigationController!.view.addSubview(timesheetDateLabel)
        
        let leftArrow:UIButton = UIButton(frame: CGRectMake(timesheetDateLabel.frame.origin.x - 37 - 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            37, 37))

        let rightArrow:UIButton = UIButton(frame: CGRectMake(CGRectGetMaxX(timesheetDateLabel.frame) + 5,
            CGRectGetMidY(timesheetDateLabel.frame) - navBarHeight/4 - 5,
            37, 37))
        
        print(CGRectGetMaxX(timesheetDateLabel.frame))
        print(timesheetDateLabel.frame.origin.x)
        
        var arrowImage = UIImage(named:"Arrow")
        arrowImage = arrowImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        leftArrow.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        leftArrow.tintColor = UIColor.whiteColor()
        rightArrow.setBackgroundImage(arrowImage, forState: UIControlState.Normal)
        rightArrow.tintColor = UIColor.whiteColor()
        leftArrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        rightArrow.enabled = false

        self.navigationController!.view.addSubview(leftArrow)
        self.navigationController!.view.addSubview(rightArrow)
    }
    
    func doStuff()
    {
        print("Hit!")
    }
}
