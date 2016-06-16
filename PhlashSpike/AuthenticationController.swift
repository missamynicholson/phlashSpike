//
//  AuthenticationController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class AuthenticationController: UIViewController {
    
    let greenView = GreenView()
    
    var usernameField = UITextField()
    var emailField = UITextField()
    var passwordField = UITextField()
    var submitButton = UIButton()
    var loginButton = UIButton()
    var signupButton = UIButton()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(greenView)
        submitButton = greenView.submitButton
        loginButton = greenView.loginButton
        signupButton = greenView.signupButton
        usernameField = greenView.usernameField
        emailField = greenView.emailField
        passwordField = greenView.passwordField
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        greenView.submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        greenView.loginButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        greenView.signupButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
    }
    
    
    /*********SIGNUP/LOGIN/LOGOUT***********/
    func buttonAction(sender: UIButton!) {
        if sender == submitButton && emailField.hidden {
            login()
        } else if sender == submitButton {
            signUp()
        } else if sender == loginButton {
            greenView.showLoginView()
        } else if sender == signupButton {
            greenView.showSignupView()
        }
    }
    
    
    //database and business//
    func signUp() {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let twentyFourHoursSince = NSDate(timeIntervalSinceReferenceDate: -86400.0)
        
        let user = PFUser()
        user.username = username!
        user.password = password!
        user.email = email!
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? NSString
                print("Error with singup \(errorMessage)")
            } else {
                //self.hideGreenView()
                self.defaults.setValue(twentyFourHoursSince, forKey: "lastSeen")
            }
        }
        
    }
    
    func login() {
        let username = usernameField.text
        let password = passwordField.text
        PFUser.logInWithUsernameInBackground(username!, password:password!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                //self.hideGreenView()
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getResetLink() {
        PFUser.requestPasswordResetForEmailInBackground("email@example.com")
    }
    //database and business//
}
