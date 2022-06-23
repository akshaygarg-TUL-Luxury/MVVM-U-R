//
//  AnyPublisher+Extension.swift
//  GithubSearch
//
//  Created by Akshay Garg on 07/05/22.
//

import Combine
import Foundation

extension AnyPublisher {
    func sink(receiveError: @escaping ((Self.Failure) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        let receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void) = { completion in
            if case let .failure(error) = completion {
                receiveError(error)
            }
        }
        return self.sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
}
