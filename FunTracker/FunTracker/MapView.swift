//
//  MapView.swift
//  FunTracker
//
//  Created by Farhad Yusufali on 2015-10-03.
//  Copyright © 2015 NIMF. All rights reserved.
//

import Foundation
import UIKit

class MapView:UIView {
 
    override func drawRect(rect: CGRect) {
        
        backgroundColor = UIColor(red: CGFloat(Double(75)/Double(255)), green:  CGFloat(Double(208)/Double(255)), blue: CGFloat(Double(190)/Double(255)), alpha: CGFloat(1))
        let ctx:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetLineWidth(ctx, 1)
        
        var heightOfDrawingView:Double = Double(self.frame.height)
        var widthOfDrawingView:Double = Double(self.frame.width)
        
        var originOfDrawingViewX:Double = 0 
        var originOfDrawingViewY:Double = 0
        
        var maxX:Double = 0
        var minX:Double = Double.infinity
        var maxY:Double = 0
        var minY:Double = Double.infinity
        
        for beacon in beacons {
            if beacon.x > maxX {
                maxX = beacon.x
            }
            if beacon.x < minX {
                minX = beacon.x
            }
            if beacon.y > maxY {
                maxY = beacon.y
            }
            if beacon.y < minY {
                minY = beacon.y
            }
        }
        
        var radiusOfBeacon:Double = 25
        
        for beacon in beacons {
            beacon.x -= minX
            beacon.y -= minY
        }
        
        var heightOfMap = maxY - minY
        var widthOfMap = maxX - minX
        
        var proportionRatio = 0.7*widthOfDrawingView/widthOfMap
        
        for beacon in beacons {
            beacon.x = beacon.x * proportionRatio + radiusOfBeacon
            beacon.y = beacon.y * proportionRatio + radiusOfBeacon
            
            CGContextSetRGBStrokeColor(ctx, CGFloat(beacon.red/255.00), CGFloat(beacon.green/255.00), CGFloat(beacon.blue/255.00), 1)
            CGContextSetRGBFillColor(ctx, CGFloat(beacon.red/255.00), CGFloat(beacon.green/255.00), CGFloat(beacon.blue/255.00), 1)
            
            var beaconCircle:CGRect = CGRectMake(CGFloat(beacon.x), CGFloat(beacon.y), CGFloat(radiusOfBeacon*Double(2)), CGFloat(radiusOfBeacon*Double(2)))
            
            CGContextFillEllipseInRect(ctx, beaconCircle)
            //Draw beacon at it's x and y coordinates with the given color
        }
        

    }
}