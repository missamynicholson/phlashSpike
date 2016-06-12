//
//  CustomOverlayView.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 12/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

protocol CustomOverlayDelegate {
    func didShoot(overlayView:CustomOverlayView)
}

class CustomOverlayView: UIView {


    @IBOutlet weak var cameraLabel: UILabel!
    
   var delegate:CustomOverlayDelegate! = nil
    
    @IBAction func shoot(sender: UIButton) {
        cameraLabel.text = "Even Cooler Camera"
        delegate.didShoot(self)
    }
}
