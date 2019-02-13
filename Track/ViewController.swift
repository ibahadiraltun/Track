//
//  ViewController.swift
//  Track
//
//  Created by Bahadir Altun on 13.02.2019.
//  Copyright © 2019 Bahadir Altun. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import SwiftProtobuf

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let locationManager: CLLocationManager = CLLocationManager()
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        stopButton.isEnabled = false
        
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
        
        // start tracking
        
        // initialize location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // initialize motion manager i.e acceleration
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates()
        
//        print(motionManager.accelerometerData)
//        print(locationManager.location)
//        print(locationManager.desiredAccuracy)
        
    }
   
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
        // stop tracking
        
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for curLocation in locations {
            
        //    print("Location -> \(index): + \(curLocation)")
            
        }
        
    }
    
}

