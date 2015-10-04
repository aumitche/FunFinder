//
//  Beacon.swift
//  FunTracker
//
//  Created by Farhad Yusufali on 2015-10-03.
//  Copyright © 2015 NIMF. All rights reserved.
//

import Foundation
import UIKit

class Beacon {
    var major = 0
    var x:Double = 0
    var y:Double = 0
    
    var red:Double
    var green:Double
    var blue:Double
    
    //Cosntructor
    init(major: Int, x: Double, y: Double) {
        self.major = major
        self.x = x
        self.y = y
        self.red = 40.0
        self.green = 247.0
        self.blue = 88.0
    }
}