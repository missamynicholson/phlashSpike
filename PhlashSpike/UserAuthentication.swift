//
//  UserAuthentication.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Parse

class UserAuthentication {
    
    func signUp(controller: UIViewController, username: String, email: String, password: String) {
        
        let twentyFourHoursSince = NSDate(timeIntervalSinceReferenceDate: -86400.0)
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? NSString
                print("Error with singup \(errorMessage)")
            } else {
                controller.performSegueWithIdentifier("toCamera", sender: nil)
                //self.defaults.setValue(twentyFourHoursSince, forKey: "lastSeen")
            }
        }

    }
    
    func login(controller: UIViewController, username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                controller.performSegueWithIdentifier("toCamera", sender: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getResetLink(email: String) {
        PFUser.requestPasswordResetForEmailInBackground(email)
    }

}
