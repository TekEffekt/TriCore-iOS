//
//  LoginVerification.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/8/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved
//

import Foundation

class LoginVerification
{
    static func login(withUsername username:String, andPassword password:String) -> Bool
    {
        NSThread.sleepForTimeInterval(1.0)
        
        if username == "Kyle" && password == "123"
        {
            return true
        } else
        {
            return false
        }
    }
}