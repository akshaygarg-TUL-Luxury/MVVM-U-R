//
//  SearchRepoViewModel.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Combine
import Foundation
import UIKit

extension Publisher where Failure == Never {
    func switchResult<T>() -> (success: AnyPublisher<T, Never>, failure: AnyPublisher<Error, Never>) where Output == Result<T, Error> {
        let source = map { output -> (T?, Error?) in
            switch output {
            case .success(let value):
                return (value, nil)
            case .failure(let error):
                return (nil, error)
            }
        }
            .share()
        let resultSuccess = source.compactMap({$0.0})
            .eraseToAnyPublisher()
        let resultFailure = source.compactMap({$0.1})
            .eraseToAnyPublisher()
        return (resultSuccess, resultFailure)
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

protocol SearchRepoInput {
    var didLoadView: PassthroughSubject<Void, Never> { get }
    var didSearch: PassthroughSubject<String, Never> { get }
    var didSelectRepo: PassthroughSubject<Int, Never> { get }
}

protocol SearchRepoOutput {
    var repositories: AnyPublisher<[User], Never> { get }
    var error: AnyPublisher<Error, Never> { get }
    var openDetails: AnyPublisher<User, Never> { get }
}

protocol SearchRepoViewModel {
    var input: SearchRepoInput { get }
    func transform() -> SearchRepoOutput
}

final class DefaultSearchRepoViewModel: SearchRepoViewModel, SearchRepoInput {
    struct Output: SearchRepoOutput {
        let repositories: AnyPublisher<[User], Never>
        let error: AnyPublisher<Error, Never>
        let openDetails: AnyPublisher<User, Never>
    }
    
    // Dependencies
    private let usecase: SearchRepoUseCase
    private let analyticsManager: AnalyticsManager
    
    // Inputs
    let didLoadView = PassthroughSubject<Void, Never>()
    let didSearch = PassthroughSubject<String, Never>()
    let didSelectRepo = PassthroughSubject<Int, Never>()
    
    var input: SearchRepoInput { self }
    
    init(usecase: SearchRepoUseCase, analyticsManager: AnalyticsManager) {
        self.usecase = usecase
        self.analyticsManager = analyticsManager
    }
    
    func transform() -> SearchRepoOutput {

        let initialApiCall = didLoadView.map({"Github"})
            .handleEvents(receiveOutput: { [unowned self] searchText in
                self.analyticsManager.track(event: .didLoadSearchScreen)
            })
            .eraseToAnyPublisher()
        
        
        let didSearchText = didSearch
            .handleEvents(receiveOutput: { [unowned self] searchText in
                self.analyticsManager.track(event: .didSearchText)
            })
            .eraseToAnyPublisher()
        
        let (success, failure) = Publishers.MergeMany(initialApiCall, didSearchText)
            .flatMap({ [unowned self] searchText -> AnyPublisher<Result<[User], Error>, Never> in
                print("===> got it before api call")
                return self.usecase.getRepositories(for: searchText)
            })
            
            .receive(on: DispatchQueue.main)
            .switchResult()
        
//        let openDetails = didSelectRepo
//            .withLatestFrom(success)
//            .compactMap { (index, repositories) -> User? in
//                print("===> openDetails: \(index) \(repositories.count)")
//                return repositories[safe: index]
//            }
        
        let up = didSelectRepo
            .flatMap { [unowned self] _ in
                self.usecase.upload(image: UIImage(named: "kitty")!, fileName: "kitty")
            }
            .map { _ in
                return User(id: 0, name: "", email: "")
            }
        
        
        return Output(
            repositories: success,
            error: failure,
            openDetails: up.eraseToAnyPublisher()
        )
    }
}
