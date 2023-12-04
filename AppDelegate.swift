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
        
        // Create the main window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Instantiate the main navigation controller
        let navigationController = UINavigationController()
        
        // Instantiate the homepage view controller
        let homepageViewController = HomepageViewController()
        
        // Set the homepage view controller as the root view controller of the navigation controller
        navigationController.viewControllers = [homepageViewController]
        
        // Set the navigation controller as the root view controller of the window
        window?.rootViewController = navigationController
        
        // Make the window visible
        window?.makeKeyAndVisible()
        
        return true
    }

}
