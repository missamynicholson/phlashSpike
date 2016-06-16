//
//  DisplayImage.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class DisplayImage {
    
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    
    func display(chosenImage: UIImage, cameraView: UIView) {
        let imageView = TheImageView(frame: CGRect(x: ImageViewFrame().getXValue(chosenImage), y: 0, width: ImageViewFrame().getNewWidth(chosenImage), height: screenBounds.height))
        cameraView.addSubview(imageView)
        imageView.image = ResizeImage().resizeImage(chosenImage, newWidth: ImageViewFrame().getNewWidth(chosenImage))
        Delay().run(3.0) {
            imageView.removeFromSuperview()
        }
    }
}
