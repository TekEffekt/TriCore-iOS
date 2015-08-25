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
    // MARK: Properties
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var taskCodeLabel: UILabel!
    @IBOutlet weak var sprintLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    var projectNameSelected:Bool = false
    var taskCodeSelected:Bool = false
    var sprintCategorySelected:Bool = false
    
    // MARK: Initialization
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    // MARK: Interaction
    @IBAction func createButtonPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func choseItem(ofType type:String, withItemName name:String)
    {
        if type == "Project Names"
        {
            self.projectNameLabel.text = name
            self.projectNameSelected = true
        } else if type == "Task Code"
        {
            self.taskCodeLabel.text = name
            self.taskCodeSelected = true
        } else
        {
            self.sprintLabel.text = name
            self.sprintCategorySelected = true
        }
        
        self.checkFields()
    }
    
    func checkFields()
    {
        if projectNameSelected && taskCodeSelected && sprintCategorySelected
        {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.createButton.alpha = 1.0
                self.createButton.enabled = true
            })
        } else
        {
            self.createButton.alpha = 0.5
            self.createButton.enabled = false
        }
    }
    
    // MARK: Tableview Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let navController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        let formsheetController = MZFormSheetPresentationController(contentViewController: navController)
        formsheetController.contentViewSize = CGSizeMake(self.view.frame.width-20,
            self.view.frame.height-self.navigationController!.navigationBar.frame.height - 40)
        
        formsheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.StyleBounce
        let popupController = navController.viewControllers.first as! PopupViewController
        popupController.masterViewController = self
        
        if indexPath.section == 0
        {
            popupController.organizedItems = Constants.organizedProjectNames
            popupController.unorganizedItems = Constants.projectNames
            popupController.contentType = "Project Names"
        } else if indexPath.section == 1
        {
            popupController.organizedItems = Constants.organizedTaskCodeNames
            popupController.unorganizedItems = Constants.taskCodeNames
            popupController.contentType = "Task Code"
        } else
        {
            popupController.organizedItems = Constants.organizedSprintNames
            popupController.unorganizedItems = Constants.sprintNames
            popupController.contentType = "Sprint Category"
        }
        
        self.presentViewController(formsheetController, animated: true, completion: nil)
    }
    
}
