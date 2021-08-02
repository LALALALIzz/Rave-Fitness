//
//  AppDelegate.swift
//  Rave Fitness
//
//  Created by liuyang on 7/25/21.
//

import UIKit
import CoreData
import CoreLocation
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let locationManager = LocationManager.shared
        locationManager.requestWhenInUseAuthorization()
        FirebaseApp.configure()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreData.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreData.saveContext()
    }

}

