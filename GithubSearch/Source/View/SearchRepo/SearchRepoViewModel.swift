//
//  SearchRepoViewModel.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation

protocol SearchRepoInput {
    func didLoadView()
    func didSearch(for text: String)
    func didSelectRepo(at: Int)
}

protocol SearchRepoOutput: AnyObject {
    func showList(with items: [Repository])
    func showView(for error: Error)
    func openDetails(with item: Repository)
}

protocol SearchRepoViewModel: SearchRepoInput {
    var repositories: [Repository] { get }
    var delegate: SearchRepoOutput { get }
    var analyticsManager: AnalyticsManager { get }
}

final class DefaultSearchRepoViewModel: SearchRepoViewModel {
    private(set) var repositories: [Repository] = []
    private let usecase: SearchRepoUseCase
    let analyticsManager: AnalyticsManager
    
    unowned let delegate: SearchRepoOutput
    
    init(usecase: SearchRepoUseCase, delegate: SearchRepoOutput, analyticsManager: AnalyticsManager) {
        self.usecase = usecase
        self.delegate = delegate
        self.analyticsManager = analyticsManager
    }
    
    func didLoadView() {
        analyticsManager.track(event: .didLoadSearchScreen)
        didSearch(for: "Github")
    }
    
    func didSearch(for text: String) {
        analyticsManager.track(event: .didSearchText)
        usecase.getRepositories(for: text) { [weak self] result in
                switch result {
                case let .success(searchResult):
                    self?.repositories = searchResult.items
                    self?.delegate.showList(with: searchResult.items)

                case let .failure(error):
                    self?.delegate.showView(for: error)
                }
        }
    }
    
    func didSelectRepo(at: Int) {
        let repo = repositories[at]
        analyticsManager.track(event: .openDetails(for: repo.name))
        delegate.openDetails(with: repo)
    }
}
