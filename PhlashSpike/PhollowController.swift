//
//  PhollowController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PhollowController: UIViewController {
    
    let phollowView = PhollowView()
    
    var usernameField = UITextField()
    var submitButton = UIButton()
    var cancelButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view = phollowView
        usernameField = phollowView.usernameField
        submitButton = phollowView.submitButton
        cancelButton = phollowView.cancelButton
        
        phollowView.submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        phollowView.cancelButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func buttonAction(sender: UIButton!) {
        if sender == submitButton {
            PhollowSomeone().phollow(usernameField.text!)
        }
        performSegueWithIdentifier("backToCamera", sender: self)
    }
}