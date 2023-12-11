//
//  AppDelegate.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        
        let homepageViewController = Homepage()
        
        navigationController.viewControllers = [homepageViewController]
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
        return true
    }

}
