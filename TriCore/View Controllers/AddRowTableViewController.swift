//
//  AddRowTableViewController.swift
//  
//
//  Created by Kyle Zawacki on 8/24/15.
//
//

import UIKit

class AddRowTableViewController: UITableViewController
{
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    @IBAction func createButtonPressed(sender: AnyObject)
    {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("popup")
        let formsheetController = MZFormSheetPresentationController(contentViewController: controller)
        formsheetController.contentViewSize = CGSizeMake(300, 450)
        
        self.presentViewController(controller, animated: true, completion: nil)
     }
}
