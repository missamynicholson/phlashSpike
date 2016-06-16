//
//  CameraController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//


import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraView = CameraView()
    
    var picker = UIImagePickerController()
    var authenticationController = AuthenticationController()
    let phollowController = PhollowController()
    
    
    override func viewDidLoad() {
        print("hello")
        super.viewDidLoad()
        cameraView.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        cameraView.logoutButton.addTarget(self, action: #selector(buttonActionLogout), forControlEvents: .TouchUpInside)
        cameraView.phollowButton.addTarget(self, action: #selector(buttonActionPhollow), forControlEvents: .TouchUpInside)
        cameraView.swipeRight.addTarget(self, action: #selector(respondToSwipeGesture))
        cameraView.swipeLeft.addTarget(self, action: #selector(respondToSwipeGesture))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadImagePicker()
    }
    
    func loadImagePicker() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            PickerSetup().makePickerFullScreen(picker)
            picker.delegate = self
            
            presentViewController(picker, animated: true, completion: {
                self.picker.cameraOverlayView = self.cameraView
            })
        }
        //if PFUser.currentUser() == nil {
            performSegueWithIdentifier("toAuth", sender: nil)
        //}
    }

    
    func buttonActionLogout(sender: UIButton!) {
        PFUser.logOut()
        performSegueWithIdentifier("toAuth", sender: nil)
    }
    
    func buttonActionPhollow(sender: UIButton!) {
        performSegueWithIdentifier("toPhollow", sender: nil)
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                picker.takePicture()
            case UISwipeGestureRecognizerDirection.Left:
                RetrievePhoto().showFirstPhlashImage(cameraView)
            default:
                break
            }
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = ResizeImage().resizeImage(chosenImage, newWidth: ImageViewFrame().getNewWidth(chosenImage))
        DisplayImage().display(chosenImage, cameraView: cameraView)
        //SendPhoto().sendPhoto(resizedImage)
    }
    
    @IBAction func unwindToCamera(segue: UIStoryboardSegue) {
        
    }
    
}

