//
//  LocationManager.swift
//  CoreLocation Sample
//
//  Created by Cédric Rolland on 14.12.18.
//  Copyright © 2018 Montion Tag. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didUpdate location: String)
}

class LocationManager: NSObject {

    var locationManagerDelegate: LocationManagerDelegate?
    private(set) var lastLocationOutput: String?

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.requestAlwaysAuthorization()
        return manager
    }()

    override init() {
        super.init()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }

        let locationOutput = "lat: \(mostRecentLocation.coordinate.latitude)\nlon: \(mostRecentLocation.coordinate.longitude)"
        lastLocationOutput = locationOutput
        locationManagerDelegate?.locationManager(self, didUpdate: locationOutput)
    }
}
