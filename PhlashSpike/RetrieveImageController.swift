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
        
        let imageView = TheImageView(frame: CGRect(x: ImageViewFrame().getXValue(phlashImage), y: 0, width:  ImageViewFrame().getNewWidth(phlashImage), height: screenBounds.height))
        self.view.addSubview(imageView)
        imageView.image = ResizeImage().resizeImage(phlashImage, newWidth: ImageViewFrame().getNewWidth(phlashImage))
        Delay().run(3.0){
            self.delegate?.retrieveImageControllerDismiss()
        }
    }

}