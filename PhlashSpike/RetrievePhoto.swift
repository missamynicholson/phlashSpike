//
//  RetrievePhoto.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//


import Parse
import UIKit

class RetrievePhoto {
    
    var phlashesArray:[PFObject] = []
    
    func showFirstPhlashImage(cameraView: UIView) {
        if phlashesArray.count < 1 {
            queryDatabaseForPhotos(cameraView)
        } else {
            let firstPhlash = phlashesArray.first
            let userImageFile = firstPhlash!["file"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let chosenImage = UIImage(data:imageData)!
                        DisplayImage().display(chosenImage, cameraView: cameraView)
                        //self.phlashesArray.removeAtIndex(0)
                    }
                }
            }
        }
    }
    
    func queryDatabaseForPhotos(cameraView: UIView) {
        //let lastSeenDate = defaults.objectForKey("lastSeen")
        
        let currentUser = PFUser.currentUser()
        let currentUsername = currentUser!.username!
        
        let phollowing = PFQuery(className:"Phollow")
        phollowing.whereKey("fromUsername", equalTo:currentUsername)
        
        let phlashes = PFQuery(className: "Phlash")
        phlashes.whereKey("username", matchesKey: "toUsername", inQuery: phollowing)
        //phlashes.whereKey("createdAt", greaterThan: lastSeenDate!)
        phlashes.orderByAscending("createdAt")
        
        
        phlashes.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = results {
                    if objects.count > 0 {
                        self.phlashesArray = objects
                        self.showFirstPhlashImage(cameraView)
                    } else {
                        print("there are \(objects.count) phlashes")
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

}
