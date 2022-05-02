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
        let networkManager = NetworkManager<SearchRepoTarget>()
        let searchUseCase = DefaultSearchRepoUseCase(networkManager: networkManager)
        
        let viewController = SearchRepoViewController.instantiateViewController()
        
        navigationController = UINavigationController(rootViewController: viewController)
        
        let analyticsManager = DefaultAnalyticsManager.shared
        
        let searchRepoViewModel = DefaultSearchRepoViewModel(usecase: searchUseCase, delegate: viewController, analyticsManager: analyticsManager)
        let searchRouter = DefaultSearchRepoRouter(navigationController: navigationController)
        
        viewController.viewModel = searchRepoViewModel
        viewController.router = searchRouter
        
        window.rootViewController = navigationController
    }
}

