//
//  SearchRepoUseCase.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation

protocol SearchRepoUseCase {
    func getRepositories(for searchText: String, completion: @escaping (Result<SearchResult, Error>) -> Void)
}

final class DefaultSearchRepoUseCase: SearchRepoUseCase {
    let networkManager: NetworkManager<SearchRepoTarget>
    
    init(networkManager: NetworkManager<SearchRepoTarget>) {
        self.networkManager = networkManager
    }
    
    func getRepositories(for searchText: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        networkManager.request(for: .getRepository(searchText: searchText), completion: completion)
    }
}
