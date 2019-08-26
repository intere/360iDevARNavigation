//
//  AppDelegate.swift
//  360iDev AR Navigation
//
//  Created by Eric Internicola on 8/11/19.
//  Copyright © 2019 Eric Internicola. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.global(qos: .utility).async {
            ScheduleService.shared.reloadBundle()
        }
        RemoteScheduleService.shared.cacheSchedule { (schedule, error) in
            if let error = error {
                return assertionFailure(error.localizedDescription)
            }
            guard schedule != nil else {
                return assertionFailure()
            }
            ScheduleService.shared.reloadBundle()
            assert(ScheduleService.shared.source == .documents)
        }
    }

}

