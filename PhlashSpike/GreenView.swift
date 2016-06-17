//
//  AuthenticationView.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class GreenView: UIView {
    
    let usernameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    
    private let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    private let whiteColor = UIColor.whiteColor()
    private let backgroundGreen: UIColor = UIColor( red: CGFloat(62/255.0), green: CGFloat(200/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(0.75))
    let submitButton = UIButton()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let logoutButton = UIButton()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buildGreenView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //view setup
    func buildGreenView() {
        frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        backgroundColor = backgroundGreen
        
        usernameField.frame = CGRect(x: 0, y: screenBounds.height/8, width: screenBounds.width, height: screenBounds.height/15)
        usernameField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        usernameField.placeholder = "Username"
        usernameField.textAlignment = .Center
        
        emailField.frame = CGRect(x: 0, y: screenBounds.height/4, width: screenBounds.width, height: screenBounds.height/15)
        emailField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        emailField.placeholder = "Email"
        emailField.textAlignment = .Center
        emailField.keyboardType = UIKeyboardType.EmailAddress
        
        passwordField.frame = CGRect(x: 0, y: screenBounds.height * 3/8, width: screenBounds.width, height: screenBounds.height/15)
        passwordField.backgroundColor = UIColor.whiteColor()
        passwordField.backgroundColor = UIColor.colorWithAlphaComponent(whiteColor)(0.5)
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .Center
        passwordField.secureTextEntry = true
        
        submitButton.frame = CGRect(x: screenBounds.width/4, y: screenBounds.height/2, width: screenBounds.width/2, height: 30)
        submitButton.setTitleColor(.whiteColor(), forState: .Normal)
        submitButton.setTitle("Submit", forState: .Normal)
        
        loginButton.frame = CGRect(x: screenBounds.width*2/5, y: screenBounds.height/2 - 50, width: screenBounds.width/5, height: 30)
        loginButton.setTitleColor(.whiteColor(), forState: .Normal)
        loginButton.setTitle("Login", forState: .Normal)
        
        
        signupButton.frame = CGRect(x: screenBounds.width*2/5, y: screenBounds.height/2, width: screenBounds.width/5, height: 30)
        signupButton.setTitleColor(.whiteColor(), forState: .Normal)
        signupButton.setTitle("Signup", forState: .Normal)

        
        addSubview(usernameField)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(submitButton)
        addSubview(loginButton)
        addSubview(signupButton)
        
        showLoginOrSignupScreen()
    }
    
    
    func showLoginOrSignupScreen() {
        usernameField.hidden = true
        passwordField.hidden = true
        submitButton.hidden = true
        emailField.hidden = true
        loginButton.hidden = false
        signupButton.hidden = false
    }
    
    func showLoginView() {
        usernameField.hidden = false
        passwordField.hidden = false
        submitButton.hidden = false
        submitButton.setTitle("Log me in", forState: .Normal)
        emailField.hidden = true
        loginButton.hidden = true
        signupButton.hidden = true
        usernameField.becomeFirstResponder()
    }
    
    func showSignupView() {
        usernameField.hidden = false
        passwordField.hidden = false
        submitButton.hidden = false
        submitButton.setTitle("Sign me up", forState: .Normal)
        
        emailField.hidden = false
        loginButton.hidden = true
        signupButton.hidden = true
        usernameField.becomeFirstResponder()
    }


}
