//
//  LoginViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/8/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tricoreName: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var keyboardShowing:Bool = false
    var keyboardHeight:CGFloat = 0
    var originalCenter:CGPoint?

    // MARK: Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tricoreName.font = self.tricoreName.font.fontWithSize(self.view.frame.width/5.5)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldPressed:", name: UIKeyboardWillShowNotification, object: nil)
        self.originalCenter = self.view.center
    }
    
    // MARK: User Interaction Events
    @IBAction func loginButtonPressed(sender: UIButton)
    {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        self.keyboardShowing = false
        self.view.center = self.originalCenter!
    }
    
    func textFieldPressed(sender:NSNotification)
    {
        print("\(sender.userInfo)")
        
        let userInfo = sender.userInfo
        
        if let userInfo = userInfo
        {
            self.keyboardHeight = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.height
            
            if(!self.keyboardShowing)
            {
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y - keyboardHeight)
                self.keyboardShowing = true
            }
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.center = self.originalCenter!
        self.keyboardShowing = false
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Login
    func attemptLogin(withUsername username:String, andPassword password:String)
    {
        
    }
    
}
