//
//  LocationViewController.swift
//  CoreLocation Sample
//
//  Created by Cédric Rolland on 14.12.18.
//  Copyright © 2018 Montion Tag. All rights reserved.
//

import UIKit

import CoreLocation

class LocationViewController: UIViewController {

    @IBOutlet weak var consoleOutputTextView: UITextView?

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }

        let newLocation = "lat: \(mostRecentLocation.coordinate.latitude)\nlon: \(mostRecentLocation.coordinate.longitude)\n\n"
        updateConsoleTextView(with: newLocation)
        print(newLocation)
    }

    private func updateConsoleTextView(with text: String) {
        consoleOutputTextView?.text = consoleOutputTextView?.text.appending(text)
        let bottom = NSMakeRange((consoleOutputTextView?.text.count ?? 0) - 1, 1)
        consoleOutputTextView?.scrollRangeToVisible(bottom)
    }
}
