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
        phollowView.frame = view.frame
        
        let buttonArray = [cameraView.logoutButton, cameraView.phollowButton, phollowView.cancelButton, phollowView.submitButton]
        for button in buttonArray {
            button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        }
    
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
        PhollowSomeone().phollow(phollowView.usernameField.text!)
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
        DisplayImage().setup(chosenImage, cameraView: cameraView, animate: false)
        //SendPhoto().sendPhoto(resizedImage)
    }
    
}

