//
//  ViewController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 12/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CustomOverlayDelegate {
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadCameraView()
    }
    
    
    func loadCameraView() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.showsCameraControls = false
            let screenBounds: CGSize = UIScreen.mainScreen().bounds.size;
            let scale = screenBounds.height / screenBounds.width;
            
            picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
            
            
            
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            
            let customView:CustomOverlayView = customViewController.view as! CustomOverlayView
            customView.frame = self.picker.view.frame
            customView.cameraLabel.text = "Hello"
            customView.delegate = self
            
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: {
                self.picker.cameraOverlayView = customView
                }
            )
        } else {
            noCamera()
        }
    }
    
    
    func didShoot(overlayView:CustomOverlayView) {
        picker.takePicture()
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
}
