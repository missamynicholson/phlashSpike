//
//  RetrieveImageController.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import Foundation
import UIKit
import Parse

protocol RetrieveImageControllerDelegate {
    func retrieveImageControllerDismiss()
}

class RetrieveImageController: UIViewController {
    
   
    let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    var delegate:RetrieveImageControllerDelegate? = nil
    var phlashImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        displayPhlash()
    }
    
    func displayPhlash() {
        
        let imageView = TheImageView(frame: CGRect(x: getXValue(phlashImage), y: 0, width: getNewWidth(phlashImage), height: screenBounds.height))
        self.view.addSubview(imageView)
        imageView.image = phlashImage
        Delay().run(3.0){
            self.delegate?.retrieveImageControllerDismiss()
        }
    }

    func getXValue(image: UIImage) -> CGFloat {
        let newWidth = getNewWidth(image)
        
        return -(newWidth-screenBounds.width)/2
    }
    
    func getNewWidth(image: UIImage) -> CGFloat {
        let newWidth:CGFloat = image.size.width/(image.size.height/screenBounds.height)
        return newWidth
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

}