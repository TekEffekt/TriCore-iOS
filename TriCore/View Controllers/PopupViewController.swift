//
//  PopupViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/22/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PopupViewController: UITableViewController, UISearchResultsUpdating
{
    // MARK: Properties
    var searchController:UISearchController = UISearchController()
    var filteredItems:[String] = [String]()
    var organizedItems = [AnyObject]()
    var unorganizedItems:[String] = [String]()
    
    var masterViewController:AddRowTableViewController?
    
    var contentType:String?
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        self.navigationController!.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    //  MARK: Search Results Methods
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredItems.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.unorganizedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredItems = array as! [String]
        
        self.tableView.reloadData()
    }
    
    // MARK: Tableview Datasource
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        self.masterViewController!.choseItem(ofType: self.contentType!, withItemName: cell!.textLabel!.text!)
        
        // A second controller is overlane if searching
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contentType! == "Project Names"
        {
            return 57
        } else
        {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if self.searchController.active
        {
            cell.textLabel!.text = self.filteredItems[indexPath.row]
        } else
        {
            cell.textLabel!.text = ((self.organizedItems[indexPath.section] as! [AnyObject])[1] as! [AnyObject])[indexPath.row] as? String
        }
        
        if self.contentType! == "Project Names"
        {
            cell.textLabel!.numberOfLines = 2
            cell.textLabel!.font = cell.textLabel!.font.fontWithSize(14.5)
        }
                
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if self.searchController.active
        {
            return 1
        } else
        {
            return self.organizedItems.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.searchController.active
        {
            return self.filteredItems.count
        } else
        {
            return  ((self.organizedItems[section] as! [AnyObject])[1] as! [AnyObject]).count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if self.searchController.active
        {
            return nil
        } else
        {
            return self.organizedItems[section].firstObject as! String
        }
    }
    
}
