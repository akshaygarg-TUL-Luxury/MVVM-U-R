//
//  RepoDetailsViewModel.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Combine
import Foundation

protocol RepoDetailsInput {
    var didLoadView: PassthroughSubject<Void, Never> { get }
    var didTapUrl: PassthroughSubject<Void, Never> { get }
}

protocol RepoDetailsOutput {
    var showDetails: AnyPublisher<User, Never> { get }
    var openURL: AnyPublisher<URL, Never> { get }
}

protocol RepoDetailsViewModel {
    var input: RepoDetailsInput { get }
    var output: RepoDetailsOutput { get }
}

final class DefaultRepoDetailsViewModel: RepoDetailsViewModel, RepoDetailsInput {
    struct Output: RepoDetailsOutput {
        let showDetails: AnyPublisher<User, Never>
        let openURL: AnyPublisher<URL, Never>
    }
    
    // Dependencies
    private(set) var repository: User
    let analyticsManager: AnalyticsManager
        
    private var cancellable = Set<AnyCancellable>()
    
    // Inputs
    let didLoadView = PassthroughSubject<Void, Never>()
    let didTapUrl = PassthroughSubject<Void, Never>()
    
    // Outputs
    let showDetails = PassthroughSubject<User, Never>()
    let openURL = PassthroughSubject<URL, Never>()
    
    var input: RepoDetailsInput { self }
    var output: RepoDetailsOutput {
        Output(
            showDetails: showDetails.eraseToAnyPublisher(),
            openURL: openURL.eraseToAnyPublisher()
        )
    }
    
    init(repository: User, analyticsManager: AnalyticsManager) {
        self.repository = repository
        self.analyticsManager = analyticsManager
        
        transform()
    }
    
    deinit {
        print("deinit : \(self)")
    }
}

extension DefaultRepoDetailsViewModel {
    func transform() {
        didLoadView
            .sink { [unowned self] _ in
                self.analyticsManager.track(event: .didLoadRepoDetailsScreen)
                self.showDetails.send(self.repository)
            }
            .store(in: &cancellable)
        
        didTapUrl
            .sink { [unowned self] _ in
                self.analyticsManager.track(event: .openURL(url: self.repository.name))
                self.openURL.send(URL(string: "self.repository.name")!)
            }
            .store(in: &cancellable)
    }
}
