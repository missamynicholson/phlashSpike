//
//  CameraController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//


import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CapturedImageControllerDelegate, RetrieveImageControllerDelegate, PhollowControllerDelegate, AuthenticationControllerDelegate {
    
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraAspectRatio:CGFloat = 4.0/3.0
    let cameraView = CameraView()
    
    var picker = UIImagePickerController()
    var authenticationController = AuthenticationController()
    let capturedImageController = CapturedImageController()
    let retrieveImageController = RetrieveImageController()
    let phollowController = PhollowController()
    var phlashesArray:[PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraView.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        cameraView.logoutButton.addTarget(self, action: #selector(buttonActionLogout), forControlEvents: .TouchUpInside)
        cameraView.phollowButton.addTarget(self, action: #selector(buttonActionPhollow), forControlEvents: .TouchUpInside)
        cameraView.swipeRight.addTarget(self, action: #selector(respondToSwipeGesture))
        cameraView.swipeLeft.addTarget(self, action: #selector(respondToSwipeGesture))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        authenticationController.delegate = self
        phollowController.delegate = self
        capturedImageController.delegate = self
        retrieveImageController.delegate = self
        loadImagePicker()
        if (PFUser.currentUser() == nil) {
            //segue to the Authentication Screen
        }
    }

    
    func buttonActionLogout(sender: UIButton!) {
        print("You have logged out")
        PFUser.logOut()
        self.picker.presentViewController(authenticationController, animated: true, completion: nil)
    }
    
    func buttonActionPhollow(sender: UIButton!) {
        print("You want to phollow someone")
        self.picker.presentViewController(phollowController, animated: true, completion: nil)
        
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                picker.takePicture()
            case UISwipeGestureRecognizerDirection.Left:
                showFirstPhlash()
            default:
                break
            }
        }
    }
    
    func showFirstPhlash() {
        if self.phlashesArray.count < 1 {
            queryDatabaseForPhotos()
        } else {
            let firstPhlash = phlashesArray.first
            let userImageFile = firstPhlash!["file"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        
                        self.retrieveImageController.phlashImage = image!
                        self.picker.presentViewController(self.retrieveImageController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func loadImagePicker() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.showsCameraControls = false
            picker.delegate = self
            picker.modalPresentationStyle = .FullScreen
            
            picker = makePickerFullScreen(picker)
            
            presentViewController(picker, animated: true, completion: {
                self.picker.cameraOverlayView = self.cameraView
                }
            )
        }
        
    }
    
    
    func makePickerFullScreen(picker: UIImagePickerController) -> UIImagePickerController {
        let camViewHeight: CGFloat = screenBounds.width * cameraAspectRatio
        let scale: CGFloat = screenBounds.height / camViewHeight
        picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
        return picker
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        capturedImageController.capturedImage = chosenImage
        self.picker.presentViewController(capturedImageController, animated: true, completion: nil)
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
                    } else {
                        print("there are \(objects.count) phlashes")
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    func capturedImageControllerDismiss() {
        self.picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func retrieveImageControllerDismiss() {
        self.picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func authenticationControllerDismiss() {
        self.picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func phollowControllerDismiss() {
        self.picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
}

