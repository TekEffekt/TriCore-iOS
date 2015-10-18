//
//  TimesheetViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 10/17/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class TimesheetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var navCont:UINavigationController?
    var manager:TimesheetManager?
    @IBOutlet weak var entryCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        entryCollectionView.delegate = self
        entryCollectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("timesheetEntry", forIndexPath: indexPath)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width, height: 148)
    }
    
}
