//
//  EBSwiftyLocationManager.swift
//  EBSwiftyLocationManager
//
//  Created by Erid Bardhaj on 3/12/16.
//  Copyright © 2016 Erid Bardhaj. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationManager {
    // MARK: Authorization
    
    /**
     Asking for the permission of the user depending on the type of authorization needed, and when an update
     pops up for that, it will be sent back with the status of authorization. The operation is dispatched on main thread.
     
     - parameter authorizationType:    The authorization type required
     - parameter distanceFilter:    Distance on meters
     - parameter desiredAccuracy:   Type used to represent a location accuracy level in meters. The lower the value in meters, the
     more physically precise the location is. A negative accuracy value indicates an invalid location.
     - parameter callback:          Notifies back the updated status code
     */
    func requestAuthorization(authorizationType: EBSwiftyLocationAuthorizationType, distanceFilter: CLLocationDistance, desiredAccuracy: CLLocationAccuracy, callback: ((status: CLAuthorizationStatus) -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            // Configure CLLocationManager
            self.distanceFilter = (distanceFilter == -1) ? 100.0 : distanceFilter
            self.desiredAccuracy = (desiredAccuracy == -1) ? kCLLocationAccuracyBestForNavigation : desiredAccuracy
            
            // Handle delegation via EBSwiftyLocationManagerDelegator
            let delegator = EBSwiftyLocationManagerDelegator.sharedInstance
            self.delegate = delegator
            delegator.didChangeAuthorizationStatusCallback = callback
            
            // Get current status
            let status = CLLocationManager.authorizationStatus()
            
            if status == .NotDetermined {
                // User has not yet made a choice about the location so show him the authorization
                self.requestToUseLocation(authorizationType)
            }
        }
    }
    
    /**
     Asking for the permission of the user depending on the type of authorization needed, and when an update
     pops up for that, it will be sent back with the status of authorization. The operation is dispatched on main thread.
     
     - parameter authorizationType:    The authorization type required
     - parameter callback:          Notifies back the updated status code
     */
    func requestAuthorization(authorizationType: EBSwiftyLocationAuthorizationType, callback: ((status: CLAuthorizationStatus) -> Void)?) {
        self.requestAuthorization(authorizationType, distanceFilter: -1, desiredAccuracy: -1, callback: callback)
    }
    
    /**
     Asking for the permission of the user depending on the type of authorization needed, and when an update
     pops up for that, it will be sent back with the status of authorization. The operation is dispatched on main thread.
     
     - parameter authorizationType:    The authorization type required
     - parameter distanceFilter:    Distance on meters
     - parameter callback:          Notifies back the updated status code
     */
    func requestAuthorization(authorizationType: EBSwiftyLocationAuthorizationType, distanceFilter: CLLocationDistance, callback: ((status: CLAuthorizationStatus) -> Void)?) {
        self.requestAuthorization(authorizationType, distanceFilter: distanceFilter, desiredAccuracy: -1, callback: callback)
    }
    
    /**
     Asking for the permission of the user depending on the type of authorization needed, and when an update
     pops up for that, it will be sent back with the status of authorization. The operation is dispatched on main thread.
     
     - parameter authorizationType:    The authorization type required
     - parameter desiredAccuracy:   Type used to represent a location accuracy level in meters. The lower the value in meters, the
     more physically precise the location is. A negative accuracy value indicates an invalid location.
     - parameter callback:          Notifies back the updated status code
     */
    func requestAuthorization(authorizationType: EBSwiftyLocationAuthorizationType, desiredAccuracy: CLLocationAccuracy, callback: ((status: CLAuthorizationStatus) -> Void)?) {
        self.requestAuthorization(authorizationType, distanceFilter: -1, desiredAccuracy: desiredAccuracy, callback: callback)
    }
    
    // MARK: Location and error handling
    
    /**
     Gets called everytime that the location updates its location with newer locations. The operation is dispatched on main thread.
     
     - parameter callback: an array of CLLocation objects in chronological order
     */
    func didUpdateLocations(callback: (locations: [CLLocation]) -> Void) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let delegator = EBSwiftyLocationManagerDelegator.sharedInstance
            delegator.didUpdateLocationsCallback = callback
        }
    }
    
    /**
     Invoked when an error has occurred. Error types are defined in "CLError.h". The operation is dispatched on main thread.
     
     - parameter callback: NSError Object
     */
    func didFailWithError(callback: ((error: NSError) -> Void)) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let delegator = EBSwiftyLocationManagerDelegator.sharedInstance
            delegator.didFailWithErrorCallback = callback
        }
    }
    
    // MARK: - Private
    
    private func requestToUseLocation(authorizationType: EBSwiftyLocationAuthorizationType) {
        switch authorizationType {
        case .WhenInUse:
            self.requestWhenInUseAuthorization()
            
        case .Always:
            self.requestAlwaysAuthorization()
        }
    }
}
