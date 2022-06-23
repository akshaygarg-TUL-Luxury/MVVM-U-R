//
//  SearchRepoUseCase.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Combine
import Foundation
import Alamofire

protocol SearchRepoUseCase {
    func getRepositories(for searchText: String) -> AnyPublisher<Result<[User], Error>, Never>
    func updateUser() -> AnyPublisher<Result<User, Error>, Never>
    func upload(image: UIImage, fileName: String) -> AnyPublisher<Result<String, Error>, Never>
}

final class DefaultSearchRepoUseCase: SearchRepoUseCase {
    let networkManager: NetworkManager<SearchRepoTarget>
    let decoder: JSONDecoder
    
    init(networkManager: NetworkManager<SearchRepoTarget>) {
        self.networkManager = networkManager
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepositories(for searchText: String) -> AnyPublisher<Result<[User], Error>, Never> {
        
        return networkManager.request(for: .getRepository(searchText: searchText))
            .map(to: [User].self, atKeyPath: "data.results.users", using: decoder)
    }
    
    func updateUser() -> AnyPublisher<Result<User, Error>, Never> {
        return networkManager.request(for: .editUser)
            .map(to: User.self)
    }
    
    func upload(image: UIImage, fileName: String) -> AnyPublisher<Result<String, Error>, Never> {
        return networkManager.upload(image: image, fileName: fileName, for: .uploadImage)
            .uploadProgress(closure: { progress in
                print("===> progress => \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { resp in
                print("===> resp = \(resp)")
            })
            .map(to: String.self, atKeyPath: "kraked_url")
    }
    
    deinit {
        print("deinit : \(self)")
    }
}
