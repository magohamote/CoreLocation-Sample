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

    private let locationManager = LocationManager()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        locationManager.locationManagerDelegate = self
    }
}

extension LocationViewController: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didUpdate output: String) {
        updateConsoleTextView(with: output)
    }

    private func updateConsoleTextView(with text: String) {
        consoleOutputTextView?.text = consoleOutputTextView?.text.appending(text)
        let bottom = NSMakeRange((consoleOutputTextView?.text.count ?? 0) - 1, 1)
        consoleOutputTextView?.scrollRangeToVisible(bottom)
    }
}
