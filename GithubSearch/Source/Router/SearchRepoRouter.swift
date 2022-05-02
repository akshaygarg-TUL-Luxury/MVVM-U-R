//
//  SearchRepoRouter.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation
import UIKit

protocol SearchRepoRouter: Router {
    func navigateToRepoDetails(for item: Repository)
}

final class DefaultSearchRepoRouter: SearchRepoRouter {
    private(set) var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToRepoDetails(for item: Repository) {
        let router = DefaultRepoDetailsRouter(navigationController: navigationController)
        let analyticsManager = DefaultAnalyticsManager.shared
        
        let detailVC = RepoDetailsViewController.instantiateViewController()
        
        let viewModel = DefaultRepoDetailsViewModel(repository: item, delegate: detailVC, analyticsManager: analyticsManager)
        
        detailVC.viewModel = viewModel
        detailVC.router = router
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
