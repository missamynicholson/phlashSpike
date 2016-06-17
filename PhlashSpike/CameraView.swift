//
//  CameraView.swift
//  PhlashSpike
//
//  Created by Amy Nicholson on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class CameraView: UIView {
    
    private let screenBounds:CGSize = UIScreen.mainScreen().bounds.size
    let logoutButton = UIButton()
    let phollowButton = UIButton()
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clearColor()
        addRightSwipe()
        addLeftSwipe()
        addLogoutButton()
        addPhollowButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addRightSwipe() {
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        addGestureRecognizer(swipeRight)
    }
    
    func addLeftSwipe() {
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        addGestureRecognizer(swipeLeft)
    }
    
    func addLogoutButton() {
        logoutButton.frame = CGRect(x: screenBounds.width*4/5, y: 20, width: screenBounds.width/5, height: 30)
        logoutButton.setTitleColor(.whiteColor(), forState: .Normal)
        logoutButton.setTitle("Logout", forState: .Normal)
        addSubview(logoutButton)
    }
    
    func addPhollowButton() {
        phollowButton.frame = CGRect(x: 0, y: 20, width: screenBounds.width/5, height: 30)
        phollowButton.setTitleColor(.whiteColor(), forState: .Normal)
        phollowButton.setTitle("Phollow", forState: .Normal)
        addSubview(phollowButton)
    }
}

