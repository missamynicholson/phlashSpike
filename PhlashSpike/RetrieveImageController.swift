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

class RetrieveImageController: UIViewController {
    
    var phlashesArray:[PFObject] = []
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    
    
       //database query//
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
    //database query
    
    
    
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
                        //let imageView = self.getNewImageView(image!, type: "received")
                        //self.overlayView.addSubview(imageView)
                        //self.swipeImageViewIn(imageView)
                    }
                }
            }
        }
    }
    
//    func swipeImageViewIn(imageView: UIImageView) {
//        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
//            imageView.frame = CGRect(x: -62.5, y: 0, width: self.screenBounds.width + 125, height: self.screenBounds.height)
//            }, completion: { finished in
//                self.delay(2.0) {
//                    self.swipeImageViewOut(imageView)
//                    //self.defaults.setValue(phlash!["createdAt"], forKey: "lastSeen")
//                    self.phlashesArray.removeAtIndex(0)
//                }
//        })
//    }
//    
//    func swipeImageViewOut(imageView: UIImageView) {
//        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
//            imageView.frame = CGRect(x: -self.screenBounds.width * 2, y: 0, width: self.screenBounds.width, height: self.screenBounds.height)
//            }, completion: { finished in
//                imageView.removeFromSuperview()
//                
//        })
//    }
    
    /*********IMAGE VIEW***********/
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getNewImageView(image: UIImage, type: String) -> UIImageView {
        let imageView:UIImageView = UIImageView()
        var xValue:CGFloat
        
        let newWidth = getNewWidth(image)
        
        xValue = screenBounds.width * 2
   
        
        imageView.frame = CGRect(x: xValue, y: 0, width: newWidth, height: screenBounds.height)
        imageView.image = resizeImage(image, newWidth: newWidth)
        
        return imageView
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

    
    //photo display//
}