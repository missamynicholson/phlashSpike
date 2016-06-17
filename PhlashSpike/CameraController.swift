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
    
    private let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    private let cameraView = CameraView()
    
    private var picker = UIImagePickerController()
    private var authenticationController = AuthenticationController()
    private let phollowView = PhollowView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.frame = view.frame
        cameraView.logoutButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        cameraView.phollowButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        cameraView.swipeRight.addTarget(self, action: #selector(respondToSwipeGesture))
        cameraView.swipeLeft.addTarget(self, action: #selector(respondToSwipeGesture))
        phollowView.frame = view.frame
        phollowView.cancelButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        phollowView.submitButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
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
            
            presentViewController(picker, animated: false, completion: {
                self.picker.cameraOverlayView = self.cameraView
            })
        }
    }

    
    func buttonAction(sender: UIButton!) {
        switch sender {
        case cameraView.logoutButton:
            logout()
        case cameraView.phollowButton:
            ButtonShowHide().hide(cameraView.logoutButton, phollowButton: cameraView.phollowButton)
            cameraView.addSubview(phollowView)
        case phollowView.cancelButton:
            ButtonShowHide().show(cameraView.logoutButton, phollowButton: cameraView.phollowButton)
            phollowView.removeFromSuperview()
        case phollowView.submitButton:
            phollow()
        default:
            break
        }
    }


    func logout() {
        PFUser.logOut()
        picker.dismissViewControllerAnimated(false, completion: {
            self.performSegueWithIdentifier("toAuth", sender: nil)
        })
    }
    
    func phollow() {
        let username = phollowView.usernameField.text
        PhollowSomeone().phollow(username!)
        phollowView.removeFromSuperview()
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
    
}

