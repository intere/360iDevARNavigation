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

        DispatchQueue.global(qos: .utility).async {
            ScheduleService.shared.loadScheduleFromBundle()
        }

        return true
    }

}

