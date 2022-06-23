//
//  DataRequest+Extension.swift
//  GithubSearch
//
//  Created by Akshay Garg on 07/05/22.
//

import Alamofire
import Combine
import Foundation

extension DataRequest {
    func map<T: Decodable>(to type: T.Type, atKeyPath: String = "", using decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Result<T,Error>, Never> {
        let preprocessor = MoveToKeyPathDataPreprocessor(keyPath: atKeyPath)

        return publishDecodable(type: type, preprocessor: preprocessor, decoder: decoder)
            .value()
            .map(Result.success)
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}
