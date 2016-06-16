//
//  SendPhoto.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit
import Parse

class SendPhoto {
    
    func sendPhoto(image: UIImage) {
        let currentUser = PFUser.currentUser()
        let currentUsername = currentUser!.username!
        
        let newWidth:CGFloat = ImageViewFrame().getNewWidth(image)
        let newImage = ResizeImage().resizeImage(image, newWidth: newWidth)
        let imageData = UIImagePNGRepresentation(newImage)
        guard let checkedImage = imageData else {
            print ("Checked Image  is nil")
            return
        }
        
        let imageFile = PFFile(name:"image.png", data:checkedImage)
        let phlash = PFObject(className: "Phlash")
        phlash["file"] = imageFile
        phlash["username"] = currentUsername
        phlash.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
                let push = PFPush()
                push.setChannel(currentUsername)
                push.setMessage("\(currentUsername) has just phlashed!")
                push.sendPushInBackground()
            } else {
                print("Error: \(error)")
            }
        }
    }
}
