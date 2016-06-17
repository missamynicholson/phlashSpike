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
    
    private let greenView = GreenView()
    
   private var usernameField = UITextField()
    private var emailField = UITextField()
    private var passwordField = UITextField()
    private var submitButton = UIButton()
    private var loginButton = UIButton()
    private var signupButton = UIButton()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("toCamera", sender: nil)
        } else {
            self.view = greenView
            submitButton = greenView.submitButton
            loginButton = greenView.loginButton
            signupButton = greenView.signupButton
            usernameField = greenView.usernameField
            emailField = greenView.emailField
            passwordField = greenView.passwordField
            submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            loginButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            signupButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        greenView.showLoginOrSignupScreen()
    }
    
    
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
    
    func login() {
        let username = usernameField.text
        let password = passwordField.text
        UserAuthentication().login(self, username: username!, password: password!)
    }
    
    func signUp() {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        UserAuthentication().signUp(self, username: username!, email: email!, password: password!)
    }
    
    func reset() {
        let email = emailField.text
        UserAuthentication().getResetLink(email!)
    }
    
    @IBAction func unwindToAuth(segue: UIStoryboardSegue) {
        
    }
    
   
}
