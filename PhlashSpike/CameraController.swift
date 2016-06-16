//
//  CameraController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//


import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CapturedImageControllerDelegate {
 
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraAspectRatio:CGFloat = 4.0/3.0
    let cameraView = CameraView()
    
    var picker = UIImagePickerController()
    
    
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
        loadImagePicker()
        cameraView.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        cameraView.logoutButton.addTarget(self, action: #selector(buttonActionLogout), forControlEvents: .TouchUpInside)
        cameraView.phollowButton.addTarget(self, action: #selector(buttonActionPhollow), forControlEvents: .TouchUpInside)
        cameraView.swipeRight.addTarget(self, action: #selector(respondToSwipeGesture))
        cameraView.swipeLeft.addTarget(self, action: #selector(respondToSwipeGesture))
    }
    
    
    func buttonActionLogout(sender: UIButton!) {
        print("You have logged out")
        PFUser.logOut()
        let authenticationController = AuthenticationController()
        self.picker.presentViewController(authenticationController, animated: true, completion: nil)
    }
    
    func buttonActionPhollow(sender: UIButton!) {
        print("You want to phollow someone")
        let phollowController = PhollowController()
        self.picker.presentViewController(phollowController, animated: true, completion: nil)

    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("You've taken a picture")
                picker.takePicture()
            case UISwipeGestureRecognizerDirection.Left:
                print("You've queried the database")
            default:
                break
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

        let capturedImageController = CapturedImageController()
        capturedImageController.capturedImage = chosenImage
        self.picker.presentViewController(capturedImageController, animated: true, completion: nil)
        
    }
    
    func capturedImageControllerDismiss() {
        self.picker.dismissViewControllerAnimated(true, completion: nil);
    }

}

