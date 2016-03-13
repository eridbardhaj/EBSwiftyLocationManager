//
//  ViewController.swift
//  EBSwiftyLocationManagerDemo
//
//  Created by Erid Bardhaj on 3/13/16.
//  Copyright © 2016 Erid Bardhaj. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager! = nil
    @IBOutlet weak var currentPositionLabel: UILabel!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize location manager
        self.locationManager = CLLocationManager()
        
        // Bind empty value
        self.currentPositionLabel.text = "Current position: \n0"
        
        // Request authorization, if we haven't done already
        self.locationManager.requestAuthorization(.WhenInUse) { (status) -> Void in
            print("Updated state for authorization: \(status)")
        }
        
        self.locationManager.didUpdateLocations { (locations) -> Void in
            let location = locations[0]
            self.currentPositionLabel.text = "Current position\n \(location.description)"
        }
        
        self.locationManager.didFailWithError { (error) -> Void in
            print("Failed with error: \(error.description)")
        }
        
        self.locationManager.startUpdatingLocation()
    }
}

