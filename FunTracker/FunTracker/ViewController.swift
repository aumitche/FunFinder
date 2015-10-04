//
//  ViewController.swift
//  FunTracker
//
//  Created by aumitche on 2015–10–02.
//  Copyright © 2015 NIMF. All rights reserved.
//

import UIKit
import SwiftHTTP

class MainViewController: UIViewController, ESTBeaconManagerDelegate {
    
    var closestBeaconMajorID:NSNumber!
    var heartBeat:Int!
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier:"ranged region")
    
    var data = ""
    var received = false //A flag that is only raised when all data has been received from the server.
    
    
    @IBOutlet var heartBeatSlider: UISlider!
    @IBOutlet var mapView: MapView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestAlwaysAuthorization()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("updateUserData"), userInfo: nil, repeats: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("updateMapData"), userInfo: nil, repeats: true)
        
        heartBeat = Int(heartBeatSlider.value)
        
        mapView.transform = CGAffineTransformMakeScale(1, -1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    override func viewDidAppear(animated: Bool) {
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion);
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)

    }
    
    func isOurBeacon(beacon: CLBeacon) -> Bool{
        return (beacon.major == 58178 || beacon.major == 61445 || beacon.major == 24884 || beacon.major == 57868)
        //return isOurBeacon
    }
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        for beacon in beacons {
            if (isOurBeacon(beacon as! CLBeacon)) {
                closestBeaconMajorID = beacon.major
                break
            }
        }
    }

    @IBAction func heartBeatChanged(sender: UISlider) {
        heartBeat = Int(sender.value)
    }
    
    func processInfo(data: String) {
        let values = data.componentsSeparatedByString(",")
        let numBeacons = (values.count - 1) / 2
        
        for (var i = 0; i < beacons.count; i++) {
            let theBeacon = beacons[i]
            theBeacon.red = 40
            theBeacon.green = 247
            theBeacon.blue = 88
        }
        for (var i = 0; i < numBeacons; i++) {
            let currMajor = Int(values[i * 2])
//            print(values[(i*2)+1])
            
 //           print(Int(values[(i*2)+1])!)
  //          print(Int("0")!)
            let currAvg = Double(values[(i*2)+1])
            for (var j = 0; j < beacons.count; j++) {
                let checkBeacon = beacons[j]
                if (checkBeacon.major == currMajor!) {
                    //Turn the number (average bpm) into three values for RGB
                    checkBeacon.red = Double(Double(currAvg!)/Double(100) * Double(247-40) + Double(40))
                    checkBeacon.green = Double(Double(currAvg!)/Double(100) * Double(40-247) + Double(247))
                    checkBeacon.blue = Double(Double(currAvg!)/Double(100) * Double(64-88) + Double(88))
                    
                    print(currMajor)
                    print(checkBeacon.red)
                    print("\n")
                }
            }
        }
        
/*        if (initial == false) {				//This is the initial request. The data returned here is one-time-only.
            //Each beacon has three properties: major, x, and y.
            for (var i = 0; i < values.count - 1; i++) {
                if (i % 3 == 0) {
                    let major = Int(values[i])
                    let x = Int(values[i + 1])
                    let y = Int(values[i + 2])
                    let beacon = EBeacon(major: major!, x: x!, y: y!)
                    beacons.append(beacon)
                }
            }
        } else {
            //RECEIVE PERIODIC DATA ABOUT HEARTBEAT AVERAGE STUFF
        }*/
    }
    
    func communicate(url: String) -> String {
        do {
            let opt = try HTTP.GET(url as String)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                //print("opt finished: \(response.description)")
                //print("\(response.data)") //access the response of the data with response.data
                self.data = String(data: response.data, encoding: NSUTF8StringEncoding)!
                print("communicate data = " + self.data)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        //It can take some time for the data to arrive from the server. Poll the data until it is not empty.
        var t = 0
        while (received == false) {
            t++
            if (data != "") {
                received = true
            }
            print(t)
        }
        
        return data
    }

    
    func updateUserData() {
        var response:String = ""
        if (closestBeaconMajorID != nil) {
            response = communicate("http://10.10.10.60/rec.php?ID=\(ID)&BPM=\(heartBeat)&BeacMajor=\(closestBeaconMajorID)")
            response = String(response.characters.dropFirst())
            processInfo(response)
        }
    }
    
    func updateMapData() {
        //Get colors of the beacons and update the beacons array
        
        /*for beacon in beacons {
            beacon.red = Double(Int(arc4random()) % 256)
            beacon.blue = Double(Int(arc4random()) % 256)
            beacon.green = Double(Int(arc4random()) % 256)
        }*/
        
        //Draw map
        drawMap()
    }
    
    func drawMap() {
        mapView.setNeedsDisplay()
    }
}