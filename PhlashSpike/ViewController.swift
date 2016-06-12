//
//  ViewController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 12/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var overlayView:UIView = UIView()
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraAspectRatio:CGFloat = 4.0/3.0
    
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
            picker.delegate = self
            picker.modalPresentationStyle = .FullScreen
            
            picker = makePickerFullScreen(picker)
            
            initialiseOverlayView(picker)
            
            presentViewController(picker, animated: true, completion: {
                self.picker.cameraOverlayView = self.overlayView
                }
            )
        }
    }
    
    func initialiseOverlayView(picker: UIImagePickerController) {
        self.overlayView.frame = picker.view.frame
        self.overlayView.backgroundColor = UIColor.clearColor()
        addRightSwipe()
    }
    
    func addRightSwipe() {
        let aSelector : Selector = #selector(ViewController.respondToSwipeGesture(_:))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: aSelector)
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.overlayView.addGestureRecognizer(swipeRight)
    }

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                self.picker.takePicture()
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            default:
                break
            }
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageView = getNewImageView(chosenImage)
        self.overlayView.addSubview(imageView)
        
        delay(3.0) {
            imageView.removeFromSuperview()
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
    
    func getNewImageView(image: UIImage) -> UIImageView {
        let imageView:UIImageView = UIImageView()
        
        let newWidth:CGFloat = image.size.width/(image.size.height/screenBounds.height)
        let xValue:CGFloat = (newWidth-screenBounds.width)/2
        
        imageView.frame = CGRect(x: -xValue, y: 0, width: newWidth, height: screenBounds.height)
        imageView.image = self.resizeImage(image, newWidth: newWidth)
        
        return imageView
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
    
    func makePickerFullScreen(picker: UIImagePickerController) -> UIImagePickerController {
        let camViewHeight: CGFloat = screenBounds.width * cameraAspectRatio
        let scale: CGFloat = screenBounds.height / camViewHeight
        picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
        return picker

    }
    
}
