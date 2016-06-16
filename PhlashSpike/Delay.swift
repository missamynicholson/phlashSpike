//
//  Delay.swift
//  PhlashSpike
//
//  Created by Admin on 16/06/2016.
//  Copyright © 2016 Amy Nicholson. All rights reserved.
//

import UIKit

class Delay {
    func run(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}