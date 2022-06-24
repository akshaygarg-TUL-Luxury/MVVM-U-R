//
//  SearchRepoViewModelTest.swift
//  GithubSearchTests
//
//  Created by Lovekesh Bhagat on 20/06/22.
//

import Foundation
import Quick
@testable import GithubSearch

// FIRST -> Fast, Independent, repeatable, self valuating , thorough
// GWT -> Given , when , then -> 3A Arrange, Act , Assert

enum SearchError: Error {
    case noNetwork
}

class SearchUseCaseMock: SearchRepoUseCase {
    
    var repositoriesResult: Result<SearchResult, Error> = .success(.init(items: []))
    
    func getRepositories(for searchText: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        completion(repositoriesResult)
    }
    
}

class SearchRepoOutputMock: SearchRepoOutput {
    
    var items: [Repository] = []
    var error: SearchError?
    var item: Repository?
    
    func showList(with items: [Repository]) {
        self.items = items
    }
    
    func showView(for error: Error) {
        self.error = error as! SearchError
    }
    
    func openDetails(with item: Repository) {
        self.item = item
    }

}

extension Repository {
    static let template = Repository(id: 1,
                                     name: "Tata cliq",
                                     full_name: "",
                                     html_url: URL(string: "www.tatacliq.com")!,
                                     description: "",
                                     created_at: Date.now,
                                     watchers: 1)
}

class AnalyticsManagerMock: AnalyticsManager {
    
    var events: [AnalyticsEvent] = []
    
    func track(event: AnalyticsEvent) {
        self.events.append(event)
    }
}

class SearchRepoViewModelTest: QuickSpec {
    
    var viewModel: DefaultSearchRepoViewModel!
    let useCase: SearchUseCaseMock = SearchUseCaseMock()
    let delegate: SearchRepoOutputMock = SearchRepoOutputMock()
    let analyticsSink: AnalyticsManagerMock = AnalyticsManagerMock()
    
    override func spec() {
        beforeEach {
            self.viewModel = DefaultSearchRepoViewModel(usecase: self.useCase,
                                                   delegate: self.delegate,
                                                   analyticsManager: self.analyticsSink)
        }
        
        describe("Search Functionality") {
            context("loading") {
                
                beforeEach {
                    self.analyticsSink.events = []
                }
                
                it("is successful with analytics") {
                    self.useCase.repositoriesResult = .success(.init(items: [.template]))
                    self.viewModel.didLoadView()
                    XCTAssert(self.analyticsSink.events == [.didLoadSearchScreen,.didSearchText])
                    XCTAssert(self.delegate.items == [.template])
                }
                
                it("is failed with analytics") {
                    self.useCase.repositoriesResult = .failure(SearchError.noNetwork)
                    self.viewModel.didLoadView()
                    XCTAssert(self.analyticsSink.events == [.didLoadSearchScreen,.didSearchText])
                    XCTAssert(self.delegate.error == .noNetwork)
                }
            }
        }
        
    }
}
