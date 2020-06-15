//
//  AppDelegate.swift
//  AnimatePolyline
//
//  Created by viensaigon on 06/15/2020.
//  Copyright (c) 2020 viensaigon. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_KEY")

        self.window?.rootViewController = ViewController()
        return true
    }
}

