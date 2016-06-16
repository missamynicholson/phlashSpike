//
//  PhollowSomeone.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Parse

class PhollowSomeone {
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
