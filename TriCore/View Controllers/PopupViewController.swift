//
//  PopupViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/22/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class PopupViewController: UITableViewController, UISearchResultsUpdating
{
    // MARK: Properties
    var searchController:UISearchController = UISearchController()
    var filteredItems:[String] = [String]()
    var organizedItems = [AnyObject]()
    var unorganizedItems:[String] = Constants.projectNames
    
    // MARK: Initialization
    override func viewDidLoad()
    {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        self.organizedItems = Constants.organizedProjectNames
        self.unorganizedItems = Constants.projectNames
        print("Loading")
    }
    
    //  MARK: Search Results Methods
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        print("Updating Search Results")
        self.filteredItems.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.unorganizedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredItems = array as! [String]
        print(self.filteredItems)
        
        print("Hitting reload data")
        self.tableView.reloadData()
        print("Reloaded Data")
    }
    
    // MARK: Tableview Datasource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        print("Grabbing Cell")
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if self.searchController.active
        {
            print(self.filteredItems)
            cell.textLabel!.text = self.filteredItems[indexPath.row]
        } else
        {
            cell.textLabel!.text = ((self.organizedItems[indexPath.section] as! [AnyObject])[1] as! [AnyObject])[indexPath.row] as? String
        }
                
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        print("Number of sections")
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
        print("Number of rows")
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
        print("Title for header")
        if self.searchController.active
        {
            return nil
        } else
        {
            return self.organizedItems[section].firstObject as! String
        }
    }
    
}
