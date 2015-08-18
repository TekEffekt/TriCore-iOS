//
//  LoginViewController.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/8/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tricoreName: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var keyboardShowing:Bool = false
    var keyboardHeight:CGFloat = 0
    var originalCenter:CGPoint?
    
    var indicatorBackground:UIView?

    // MARK: Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tricoreName.font = self.tricoreName.font.fontWithSize(self.view.frame.width/5.5)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldPressed:", name: UIKeyboardWillShowNotification, object: nil)
        self.originalCenter = self.view.center
        
        self.indicatorBackground = UIView(frame: self.view.frame)
        self.indicatorBackground!.backgroundColor = UIColor.blackColor()
        self.indicatorBackground!.alpha = 0.0
    }
    
    // MARK: User Interaction Events
    @IBAction func loginButtonPressed(sender: UIButton)
    {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        self.keyboardShowing = false
        self.view.center = self.originalCenter!
        
        attemptLogin(withUsername: self.usernameField.text!, andPassword: self.passwordField.text!)
    }
    
    func textFieldPressed(sender:NSNotification)
    {        
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
        startAndSetupIndicator()
        
        let queue = NSOperationQueue()
        queue.addOperationWithBlock { () -> Void in
            var loginSuccesfull:Bool = LoginVerification.login(withUsername: username, andPassword: password)
            
            if(loginSuccesfull)
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.removeIndicator()
                    self.fadeOutScreen()
                })
            } else
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.removeIndicator()
                    self.shakeTextFields()
                    self.vibratePhone()
                })
            }
        }
    }
    
    func startAndSetupIndicator()
    {
        self.view.insertSubview(self.indicatorBackground!, belowSubview: self.indicator)
        self.indicator.hidden = false
        self.indicator.startAnimating()
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.indicator.alpha = 1.0
            self.indicatorBackground!.alpha = 0.9
        }
    }
    
    func removeIndicator()
    {
        self.indicatorBackground!.removeFromSuperview()
        self.indicator.stopAnimating()
        self.indicator.alpha = 0.0
        self.indicator.hidden = true
        self.indicatorBackground!.alpha = 0.0
    }
    
    func shakeTextFields()
    {
        self.usernameField.text = ""
        self.passwordField.text = ""
        
        shake(view: self.usernameField, inDirection: 6.0, andShakesDone: 0)
        shake(view: self.passwordField, inDirection: 6.0, andShakesDone: 0)
    }
    
    func shake(view view:UIView, var inDirection direction:CGFloat, var andShakesDone shakes:Int)
    {
        UIView.animateWithDuration(0.04, animations: { () -> Void in
            view.transform = CGAffineTransformMakeTranslation(direction, 0)
            }) { (Bool) -> Void in
                if shakes >= 10
                {
                    view.transform = CGAffineTransformIdentity
                    return
                }
                shakes++
                direction = CGFloat(direction * -1)
                self.shake(view: view, inDirection: direction, andShakesDone: shakes)
        }
    }
    
    func vibratePhone()
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // MARK: Navigation
    
    func fadeOutScreen()
    {
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + self.navigationController!.navigationBar.frame.height)
        let blackness:UIView = UIView(frame: frame)
        blackness.backgroundColor = UIColor.blackColor()
        blackness.alpha = 0.0
        
        //self.view.addSubview(blackness)
        self.navigationController!.view.addSubview(blackness)
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            blackness.alpha = 1.0
            }) { (Bool) -> Void in
                self.performSegueWithIdentifier("showTabController", sender: self)
        }
    }
    
}
