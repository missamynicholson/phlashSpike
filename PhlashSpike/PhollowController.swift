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

protocol PhollowControllerDelegate {
    func phollowControllerDismiss()
}

class PhollowController: UIViewController {
    
    let phollowView = PhollowView()
    
    var usernameField = UITextField()
    var submitButton = UIButton()
    var cancelButton = UIButton()
    
    var delegate: PhollowControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view = phollowView
        usernameField = phollowView.usernameField
        submitButton = phollowView.submitButton
        cancelButton = phollowView.cancelButton
        
        phollowView.submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
         phollowView.cancelButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        self.delegate?.phollowControllerDismiss()
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
            phollow(usernameField.text!)
        } else {
            self.delegate?.phollowControllerDismiss()
        }
    }
    
    func phollow(toUsername: String) {
        let currentUser = PFUser.currentUser()
        guard let checkedUser = currentUser else {
            print ("Checked User  is nil")
            return
        }
        
        let phollow = PFObject(className:"Phollow")
        phollow["fromUsername"] = checkedUser.username
        phollow["toUsername"] = toUsername
        phollow.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(toUsername, forKey: "channels")
                currentInstallation.saveInBackground()
            } else  {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}