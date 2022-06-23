//
//  AppRouter.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation
import UIKit

final class AppRouter: Router {
    let window: UIWindow
    private(set) var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let vc = InitialViewController.instantiateViewController()
        navigationController = UINavigationController(rootViewController: vc)
        let router = DefaultInitialViewRouter(navigationController: navigationController)
        vc.router = router
        window.rootViewController = navigationController
    }
}

