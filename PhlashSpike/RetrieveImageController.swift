//
//  RetrieveImageController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Foundation
import UIKit
import Parse

protocol RetrieveImageControllerDelegate {
    func retrievedImageControllerDismiss()
}

class RetrieveImageController: UIViewController {
    
    var phlashesArray:[PFObject] = []
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    var delegate:RetrieveImageControllerDelegate? = nil
    
    
    //received photo display//
    func showFirstPhlash() {
        if self.phlashesArray.count < 1 {
            queryDatabaseForPhotos()
        } else {
            let phlash = phlashesArray.first
            let userImageFile = phlash!["file"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        let imageView = TheImageView(frame: CGRect(x: self.getXValue(image!), y: 0, width: self.getNewWidth(image!), height: self.screenBounds.height))
                        self.view.addSubview(imageView)
                        imageView.image = image
                        self.delay(3.0) {
                            self.delegate?.retrievedImageControllerDismiss()
                        }
                    }
                }
            }
        }
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getXValue(image: UIImage) -> CGFloat {
        let newWidth = getNewWidth(image)
        
        return -(newWidth-screenBounds.width)/2
    }
    
    func getNewWidth(image: UIImage) -> CGFloat {
        let newWidth:CGFloat = image.size.width/(image.size.height/screenBounds.height)
        return newWidth
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let newSize: CGSize = CGSizeMake(newWidth, screenBounds.height)
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    
    
    func queryDatabaseForPhotos() {
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
                        self.showFirstPhlash()
                        print("there are \(objects.count) phlashes")
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