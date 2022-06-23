//
//  AppDelegate.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let appRouter: AppRouter = AppRouter(window: window)
        appRouter.start()
        window.makeKeyAndVisible()
    
        return true
    }
}
