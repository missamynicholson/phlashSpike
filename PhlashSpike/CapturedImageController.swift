//
//  CapturedImageController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Foundation
import UIKit
import Parse

protocol CapturedImageControllerDelegate {
    func capturedImageControllerDismiss()
}

class CapturedImageController: UIViewController {
    
    var capturedImage : UIImage?
    var delegate:CapturedImageControllerDelegate? = nil
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setImage()
        
    }
    
    
    func setImage() {
        if let image = capturedImage {
            let imageView = TheImageView(frame: CGRect(x: getXValue(image), y: 0, width: getNewWidth(image), height: screenBounds.height))
            self.view.addSubview(imageView)
            imageView.image = image
            delay(3.0) {
                self.delegate?.capturedImageControllerDismiss()
            }
        } else {
            // no data was obtained
        }
    }

    
    //HELPER
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
    //HELPER

    
    
    
    
    

    
    //captured photo manipulation
    

    //captured photo manipulation
    
    
    //database//
    func sendPhoto(image: UIImage) {
        let currentUser = PFUser.currentUser()
        let currentUsername = currentUser!.username!
        
        let newWidth:CGFloat = getNewWidth(image)
        let newImage = resizeImage(image, newWidth: newWidth)
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
    //database
    
   
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}


