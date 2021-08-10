//
//  AppDelegate.swift
//  Meteors
//
//  Created by bhuvan on 06/08/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Fetch the meteor list
        let viewModel = MeteorViewModel()
        if viewModel.getSavedMeteors().count == 0 {
            MeteorViewModel().fetchMeteors { }
        }
        return true
    }
}

