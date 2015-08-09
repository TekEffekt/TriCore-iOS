//
//  LoginViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/8/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tricoreName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tricoreName.font = self.tricoreName.font.fontWithSize(self.view.frame.width/5.5)
        print("Font Size: \(self.view.frame.width/5.5)")
    }
    
    
}
