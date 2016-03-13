//
//  EBSwiftyLocationManagerDelegator.swift
//  EBSwiftyLocationManager
//
//  Created by Erid Bardhaj on 3/12/16.
//  Copyright © 2016 Erid Bardhaj. All rights reserved.
//

import UIKit
import CoreLocation

enum EBSwiftyLocationAuthorizationType {
    case Always
    case WhenInUse
    
    func selector() -> Selector {
        switch self {
        case .Always:
            return "requestAlwaysAuthorization"
            
        case .WhenInUse:
            return "requestWhenInUseAuthorization"
        }
    }
}

class EBSwiftyLocationManagerDelegator: NSObject, CLLocationManagerDelegate {
    /// Singleton Pattern
    static let sharedInstance = EBSwiftyLocationManagerDelegator()
    
    /// Callbacks
    var didChangeAuthorizationStatusCallback: ((status: CLAuthorizationStatus) -> Void)?
    var didUpdateLocationsCallback: ((locations: [CLLocation]) -> Void)?
    var didFailWithErrorCallback: ((error: NSError) -> Void)?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Delegation
    
    // MARK: CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.didChangeAuthorizationStatusCallback?(status: status)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.didUpdateLocationsCallback?(locations: locations)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.didFailWithErrorCallback?(error: error)
    }
}
