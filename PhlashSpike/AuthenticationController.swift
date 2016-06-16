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
            self.view = greenView
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
        submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        loginButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        signupButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
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
        UserAuthentication().login(username!, password: password!)
    }
    
    func signUp() {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        UserAuthentication().signUp(username!, email: email!, password: password!)
    }
    
    func reset() {
        let email = emailField.text
        UserAuthentication().getResetLink(email!)
    }
    
   
}
