//
//  RepoDetailsViewModel.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

protocol RepoDetailsInput {
    func didLoadView()
    func didTapUrl()
}

protocol RepoDetailsOutput: AnyObject {
    func open(url: URL)
}

protocol RepoDetailsViewModel: RepoDetailsInput {
    var repository: Repository { get }
    var delegate: RepoDetailsOutput { get }
    var analyticsManager: AnalyticsManager { get }
}

final class DefaultRepoDetailsViewModel: RepoDetailsViewModel {
    private(set) var repository: Repository
    let analyticsManager: AnalyticsManager
    
    unowned let delegate: RepoDetailsOutput
    
    init(repository: Repository, delegate: RepoDetailsOutput, analyticsManager: AnalyticsManager) {
        self.repository = repository
        self.delegate = delegate
        self.analyticsManager = analyticsManager
    }
    
    func didLoadView() {
        analyticsManager.track(event: .didLoadRepoDetailsScreen)
    }
    
    func didTapUrl() {
        analyticsManager.track(event: .openURL(url: repository.html_url.absoluteString))
        delegate.open(url: repository.html_url)
    }
}
