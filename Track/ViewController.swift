//
//  ViewController.swift
//  Track
//
//  Created by Bahadir Altun on 13.02.2019.
//  Copyright © 2019 Bahadir Altun. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreMotion
import SwiftProtobuf

// Acceleration class to keep current acceleration and time to compare with other locations
class Acceleration {
    
    var accData: ProtoFiles_AccData = ProtoFiles_AccData()
    var time = Double()
    
    init(_accData: ProtoFiles_AccData, _time: Double) {
        accData = _accData
        time = _time
    }
    
}

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let locationManager: CLLocationManager = CLLocationManager()
    let motionManager: CMMotionManager = CMMotionManager()
    
    // timer to save data every 10 seconds
    var timer = Timer()
    var currentTime = 0.0
    let startTime = Date().timeIntervalSinceReferenceDate

    var unitFile = ProtoFiles_UnitFile()
    
    var accelerations: [Acceleration] = [Acceleration]()
    
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
        
        // initialize unitFile
        unitFile = ProtoFiles_UnitFile()
        
        // initialize location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // initialize motion manager i.e acceleration
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let _data = data {
                
                // to keep acceleration data between current and previous locations
                
                var accData = ProtoFiles_AccData()
                accData.timestamp = self.currentTime
                accData.x = Float((_data.acceleration.x))
                accData.y = Float((_data.acceleration.y))
                accData.z = Float((_data.acceleration.z))

                self.accelerations.append(Acceleration(_accData: accData, _time: self.currentTime))
            }
        }
        
        // initialize timer to repeat every 3 seconds
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.saveData), userInfo: nil, repeats: true)
        
    }
   
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
        // stop timing
        timer.invalidate()
        
        // stop tracking
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
        
        saveUnitFile()
        
    }
    
    @objc func saveData() {
        
        currentTime = currentTime + 3.0
        
        print("Next Save -- > \(currentTime)")
        
        let currentLoc = locationManager.location
        var locData = ProtoFiles_LocData()

        locData.timestamp = currentTime
        locData.latitude = Float((currentLoc?.coordinate.latitude)!)
        locData.longitude = Float((currentLoc?.coordinate.longitude)!)
        locData.accuracy = Float(locationManager.desiredAccuracy)
        locData.speed = Float((currentLoc?.speed)!)
        
        for each in accelerations {
            locData.accData.append(each.accData)
        }
        
        // we only need to keep accelerations between current and previous locations, so we can clear [accelerations] to use memory better
        accelerations = [Acceleration]()
        
        print(locData)
     
        unitFile.locData.append(locData)
        
    }
    
    func saveUnitFile() {
        
        let endTime = Date().timeIntervalSinceReferenceDate

        unitFile.driverID = UInt64((UIDevice.current.identifierForVendor?.hashValue)!)
        unitFile.timezoneoffset = Int32(TimeZone.current.secondsFromGMT())
        unitFile.startTime = startTime
        unitFile.endTime = endTime
        
        print(unitFile)
        var binaryData: Data = Data()
        
        do {
            binaryData = try unitFile.serializedData()
        } catch {
            print("Some error occured while serializing data")
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dataURL = URL(fileURLWithPath: "TrackingData", relativeTo: paths[0])
        
        do {
            try binaryData.write(to: dataURL)
        } catch {
            print("Some error occured while saving data")
        }
        
    }
    
}
