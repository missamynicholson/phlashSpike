import Parse
import Foundation

class Authentication: NSObject {
    
    func signUp(username: String, email: String, password: String) -> Void {
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                print("Error with singup")
                _ = error.userInfo["error"] as? NSString
                
                // Show the errorString somewhere and let the user try again.
            } else {
                print("User signed up")
                // Hooray! Let them use the app now.
//                self.hideGreenView()
//                self.defaults.setValue(twentyFourHoursSince, forKey: "lastSeen")
                
            }
        }
        
    }
    
    
}

//
//  AuthenticationModel.swift
//  PhlashSpike
//
//  Created by Ollie Haydon-Mulligan on 15/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//


