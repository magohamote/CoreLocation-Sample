//
//  AppDelegate.swift
//  CoreLocation Sample
//
//  Created by Cédric Rolland on 14.12.18.
//  Copyright © 2018 Montion Tag. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let locationManager = LocationManager()
    private let motionManager = MotionManager()
    private let currentDateKey = "currentDate"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.locationManagerDelegate = self
        motionManager.motionManagerDelegate = self
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(Date(), forKey: currentDateKey)
        let noMotionData = "We cannot deliver motion activity when app is in background\nWe will display a list of motion that happened when you reopen the app\n"
        print(noMotionData)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let didEnterBackgroundDate = UserDefaults.standard.value(forKey: currentDateKey) as? Date else {
            return
        }

        motionManager.getBackgroundMotionActivities(from: didEnterBackgroundDate) { (activities, error) in
            guard let activities = activities else {
                return
            }

            if activities.count > 0 {

                print("\n--------------------\n")
                print("the motion activity that happened in background\n")

                activities.forEach { print($0) }

                print("--------------------\n")
            }
        }
    }

    private func updateConsole(withLocation location: String?, meanOfTransportation: String?) {
        if let location = location {
            print(location)
        }

        if UIApplication.shared.applicationState == .active {
            if let meanOfTransportation = meanOfTransportation {
                print(meanOfTransportation)
            } else {
                print("\n")
            }
        }
    }
}

extension AppDelegate: LocationManagerDelegate {
    func locationManagerDidUpdate(_ locationManager: LocationManager) {
        updateConsole(withLocation: locationManager.lastLocationOutput, meanOfTransportation: motionManager.lastDetectedMeanOfTransportation)
    }
}

extension AppDelegate: MotionManagerDelegate {
    func motionManagerDidUpdate(_ motionManager: MotionManager) {
        updateConsole(withLocation: locationManager.lastLocationOutput, meanOfTransportation: motionManager.lastDetectedMeanOfTransportation)
    }
}

