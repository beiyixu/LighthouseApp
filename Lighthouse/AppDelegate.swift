//
//  AppDelegate.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = MainTabBarController()
        return true
    }

    
    
}
