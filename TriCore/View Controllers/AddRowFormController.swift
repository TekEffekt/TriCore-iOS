//
//  AddRowFormController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/22/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class AddRowFormController: UIViewController, UITableViewDelegate
{
    @IBOutlet weak var container: UIView!
    var timesheetController:TimesheetsViewController?
    
    override func viewDidLoad()
    {
       let controller = self.childViewControllers.first as! AddRowTableViewController
        controller.timesheetController = self.timesheetController!
    }
    
    
    @IBAction func closeButtonClosed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
