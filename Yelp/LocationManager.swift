//
//  LocationManager.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locationData = ["location" : location]
            NotificationCenter.default.post(name: .device_location_changed, object: self, userInfo: locationData)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Charles \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        if (status != .denied) {
            startTracking()
        }
    }
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
}
