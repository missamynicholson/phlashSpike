//
//  PickerSetup.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class PickerSetup {
    
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let cameraAspectRatio:CGFloat = 4.0/3.0
    
    func makePickerFullScreen(picker: UIImagePickerController) {
        let camViewHeight: CGFloat = screenBounds.width * cameraAspectRatio
        let scale: CGFloat = screenBounds.height / camViewHeight
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        picker.showsCameraControls = false
        picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
    }

    
}
