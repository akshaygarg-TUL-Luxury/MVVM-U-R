//
//  RepoDetailsRouter.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation
import UIKit

protocol RepoDetailsRouter: Router {
    func open(url: URL)
}

final class DefaultRepoDetailsRouter: RepoDetailsRouter {
    private(set) var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

