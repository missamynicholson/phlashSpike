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
            let imageView = TheImageView(frame: CGRect(x: ImageViewFrame().getXValue(image), y: 0, width: ImageViewFrame().getNewWidth(image), height: screenBounds.height))
            self.view.addSubview(imageView)
            imageView.image = ResizeImage().resizeImage(image, newWidth: ImageViewFrame().getNewWidth(image))
            //sendPhoto(ResizeImage().resizeImage(image, newWidth: getNewWidth(image)))
            Delay().run(3.0) {
                print("here")
                self.delegate?.capturedImageControllerDismiss()
            }
        } else {
            // no data was obtained
        }
    }
    
    
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
