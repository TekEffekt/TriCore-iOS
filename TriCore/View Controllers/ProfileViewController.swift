//
//  ProfileViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/10/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekTitleLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayTitleLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var holidayTitleLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    @IBOutlet weak var compTitleLabel: UILabel!
    @IBOutlet weak var vacationLabel: UILabel!
    @IBOutlet weak var vacationTitleLabel: UILabel!
    
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var titleLabels: [UILabel]!
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var employeeTitle: UILabel!
    @IBOutlet weak var employeeNameTitle: UILabel!
    
    // MARK: Initialization
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController!.navigationBarHidden = false
        self.tabBarController!.navigationItem.leftBarButtonItem = nil
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
        
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Bordered, target: self, action: "logoutUser")
        
        self.tabBarController!.navigationItem.title = "Your Profile"
        
        styleTimeLabels()
        styleTitleLables()
    }
    
    func styleTimeLabels()
    {
        for label in self.timeLabels
        {
            label.font = label.font.fontWithSize(self.view.frame.width/6.5)
            label.sizeToFit()
        }
    }
    
    func styleTitleLables()
    {
        for label in self.titleLabels
        {
            label.font = label.font.fontWithSize(self.view.frame.width/21)
            label.sizeToFit()
        }
        
        self.hourLabel.font = self.hourLabel.font.fontWithSize(self.view.frame.height/20)
        self.employeeTitle.font = self.employeeTitle.font.fontWithSize(self.view.frame.width/17)
        self.employeeNameTitle.font = self.employeeNameTitle.font.fontWithSize(self.view.frame.width/13)
    }
    
    // Login
    func logoutUser()
    {
        
    }
    
}
