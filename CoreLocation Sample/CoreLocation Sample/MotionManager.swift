//
//  MotionManager.swift
//  CoreLocation Sample
//
//  Created by Cédric Rolland on 14.12.18.
//  Copyright © 2018 Montion Tag. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManager: NSObject {

    var motionResult: MotionResult?

    typealias MotionResult = (meanOfTransportation: [MeanOfTransportation], confidence: String)

    enum MeanOfTransportation: String {
        case walking = "walking 🚶🏼‍♂️"
        case running = "running 🏃🏼‍♂️💨"
        case onFootStopped = "on foot, standing"
        case cycling = "biking 🚴🏼‍♂️💨"
        case cycleStopped = "on a bike, standing 🚴🏼‍♂️"
        case driving = "driving 🚗💨"
        case driveStopped = "in a car, stopped 🚗"
        case unknown
    }

    private let motionManager = CMMotionActivityManager()

    override init() {
        super.init()

        if !CMMotionActivityManager.isActivityAvailable() {
            // ask user for permission
            return
        }

        motionManager.startActivityUpdates(to: .main) { (activity) in
            guard let activity = activity else {
                return
            }

            self.motionResult = self.getMotionResult(activity)
        }
    }

    func getBackgroundMotionActivies(from fromDate: Date, completion: @escaping (_ activites: [MotionResult]?, _ error: Error?) -> Void) {
        motionManager.queryActivityStarting(from: fromDate, to: Date(), to: .main) { (activities, error) in
            guard let activities = activities else {
                return
            }

            var motionResults = [MotionResult]()

            for activity in activities {
                motionResults.append(self.getMotionResult(activity))
            }

            completion(motionResults, error)
        }
    }

    private func getMotionResult(_ activity: CMMotionActivity) -> MotionResult {
        var meansOfTransportation = [MeanOfTransportation]()

        if activity.walking {
            if activity.stationary {
                meansOfTransportation.append(.onFootStopped)
            } else {
                meansOfTransportation.append(.walking)
            }
        }

        if activity.running {
            if activity.stationary {
                meansOfTransportation.append(.onFootStopped)
            } else {
                meansOfTransportation.append(.running)
            }
        }

        if activity.cycling {
            if activity.stationary {
                meansOfTransportation.append(.cycleStopped)
            } else {
                meansOfTransportation.append(.cycling)
            }
        }

        if activity.automotive {
            if activity.stationary {
                meansOfTransportation.append(.driveStopped)
            } else {
                meansOfTransportation.append(.driving)
            }
        }

        if activity.unknown || (!activity.walking && !activity.running && !activity.cycling && !activity.automotive) {
            meansOfTransportation.append(.unknown)
        }

        return (meansOfTransportation, getConfidence(activity.confidence))
    }

    private func getConfidence(_ confidence: CMMotionActivityConfidence) -> String {
        var confidenceString = "confidence: "

        switch confidence {
        case .low:
            confidenceString += "low\n"
        case .medium:
            confidenceString += "medium\n"
        case .high:
            confidenceString += "high\n"
        }

        return confidenceString
    }
}