//
//  AppDelegate.swift
//  MapsApp
//
//  Created by Кирилл Романенко on 14.11.2020.
//

import UIKit
import GoogleMaps

let googleApiKey = "AIzaSyCGyDUqXPChHjkuFUc3LUJZeuC2rCED-rE"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(googleApiKey)
        
        return true
    }

}

