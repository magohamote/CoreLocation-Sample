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
    func locationManager(_ locationManager: LocationManager, didUpdate output: String)
}

class LocationManager: NSObject {

    var locationManagerDelegate: LocationManagerDelegate?

    private var locationOutput: String? {
        didSet {
            guard let locationOutput = locationOutput else {
                return
            }

            locationManagerDelegate?.locationManager(self, didUpdate: locationOutput)
        }
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()

    override init() {
        super.init()

        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }

        locationOutput = "lat: \(mostRecentLocation.coordinate.latitude)\nlon: \(mostRecentLocation.coordinate.longitude)"
    }
}
