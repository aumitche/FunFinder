//
//  AppDelegate.swift
//  FunTracker
//
//  Created by aumitche on 2015–10–02.
//  Copyright © 2015 NIMF. All rights reserved.
//

import UIKit
import SwiftHTTP

//1. Add the ESTBeaconManagerDelegate protocol

var beacons = [Beacon]()


var ID:Int!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

	var window: UIWindow?
    var data = ""
    var received = false //A flag that is only raised when all data has been received from the server.

	//2. Add a property to hold the beacon manager and instantiate it
	let beaconManager = ESTBeaconManager()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		//3. Set the beacon manager's delegate
		self.beaconManager.delegate = self
		self.beaconManager.requestAlwaysAuthorization()
        
        getBeaconLocations()
		return true
	}
    
    func getBeaconLocations() {
        //First thing: contact the server for the pre-determined beacon locations.
        let initialData = communicate("http://10.10.10.60/getInitInfo.php")
        print("initialData = " + initialData)
        processInfo(initialData)
    }
    
    func communicate(url: String) -> String {
        do {
            let opt = try HTTP.GET(url as String)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                print("\(response.data)") //access the response of the data with response.data
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
            if (t % 1000000 == 0) {
                print(t)
            }
        }
        
        return data
    }

    func processInfo(data: String) {
        let values = data.componentsSeparatedByString(",")
        
        //Each beacon has three properties: major, x, and y.
        for (var i = 0; i < values.count - 1; i++) {
            if (i % 3 == 0 && values.count - i > 3) {
                let major = Int(values[i])
                let x = Double(values[i + 1])
                let y = Double(values[i + 2])
                let beacon = Beacon(major: major!, x: x!, y: y!)
                beacons.append(beacon)
            }
        }
        ID = Int(values[values.count - 2])
        print(ID)
        _ = 0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

