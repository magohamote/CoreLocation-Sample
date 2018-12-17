//
//  LocationViewController.swift
//  CoreLocation Sample
//
//  Created by Cédric Rolland on 14.12.18.
//  Copyright © 2018 Montion Tag. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var consoleOutputTextView: UITextView?

    private let locationManager = LocationManager()
    private let motionManager = MotionManager()
    private let currentDateKey = "currentDate"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()

        locationManager.locationManagerDelegate = self
        motionManager.motionManagerDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc private func didEnterBackground() {
        UserDefaults.standard.set(Date(), forKey: currentDateKey)
        let noMotionData = "We cannot deliver motion activity when app is in background\nWe will display a list of motion that happened when you reopen the app\n"
        updateConsoleOutput(text: noMotionData)
    }

    @objc private func didBecomeActive() {
        guard let didEnterBackgroundDate = UserDefaults.standard.value(forKey: currentDateKey) as? Date else {
            return
        }

        motionManager.getBackgroundMotionActivies(from: didEnterBackgroundDate) { (activities, error) in
            guard let activities = activities else {
                return
            }

            if activities.count > 0 {

                self.updateConsoleOutput(text: "\n--------------------\n")
                self.updateConsoleOutput(text: "the motion activity that happened in background\n")

                activities.forEach { self.updateConsoleOutput(text: $0) }

                self.updateConsoleOutput(text: "--------------------\n")
            }
        }
    }

    private func updateConsoleTextView(withLocation location: String?, motion: String?) {
        if let location = location {
            updateConsoleOutput(text: location)
        }

        if UIApplication.shared.applicationState == .active {
            if let motion = motion {
                updateConsoleOutput(text: motion)
            } else {
                updateConsoleOutput(text: "\n")
            }
        }
    }

    private func updateConsoleOutput(text: String) {
        print(text)
        consoleOutputTextView?.text = consoleOutputTextView?.text.appending(text + "\n")
        let bottom = NSMakeRange((consoleOutputTextView?.text.count ?? 0) - 1, 1)
        consoleOutputTextView?.scrollRangeToVisible(bottom)
    }
}

extension LocationViewController: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didUpdate output: String) {
        print("location update")
        updateConsoleTextView(withLocation: output, motion: motionManager.motionResultString)
    }
}

extension LocationViewController: MotionManagerDelegate {
    func motionManager(_ motionManager: MotionManager, didUpdate activity: String) {
        print("motion update")
        updateConsoleTextView(withLocation: locationManager.locationOutput, motion: activity)
    }
}
