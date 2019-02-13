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

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager: CLLocationManager = CLLocationManager()
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        // start tracking
        
        // initialize location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // initialize motion manager i.e acceleration
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (_data, error) in
            if let data = _data {
                print(data)
            }
        }
        
        
    }
   
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        // stop tracking
        
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for curLocation in locations {
            
            print("Location -> \(index): + \(curLocation)")
            
        }
        
    }
    
}

