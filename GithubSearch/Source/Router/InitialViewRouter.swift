//
//  InitialViewRouter.swift
//  GithubSearch
//
//  Created by Akshay Garg on 13/05/22.
//

import Foundation
import UIKit

protocol InitialViewRouter: Router {
    func navigateToSearchPage()
}

final class DefaultInitialViewRouter: InitialViewRouter {
    private(set) var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSearchPage() {
        let networkManager = NetworkManager<SearchRepoTarget>()
        let searchUseCase = DefaultSearchRepoUseCase(networkManager: networkManager)
        
        let viewController = SearchRepoViewController.instantiateViewController()
        
        let analyticsManager = DefaultAnalyticsManager.shared
        
        let searchRepoViewModel = DefaultSearchRepoViewModel(usecase: searchUseCase, analyticsManager: analyticsManager)
        let searchRouter = DefaultSearchRepoRouter(navigationController: navigationController)
        
        viewController.viewModel = searchRepoViewModel
        viewController.router = searchRouter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
