//
//  SearchRepoTarget.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Foundation

enum SearchRepoTarget {
    case getRepository(searchText: String)
    case getDetails(id: String)
}

extension SearchRepoTarget: TargetType {
    var baseUrl: String {
        switch self {
        case .getRepository:
            return "https://api.github.com/"
            
        case .getDetails:
            return "https://tatacliq.com/"
        }
    }
    
    var endpoint: String {
        switch self {
        case .getRepository:
            return "search/repositories"
        case .getDetails:
            return "/getDetails"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getRepository, .getDetails:
            return [
                "Accept": "application/vnd.github.v3+json"
            ]
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case let .getRepository(searchText):
            return [
                "q": searchText
            ]
            
        case let .getDetails(id):
            return [
                "id": id
            ]
        }
    }
    
    var decoder: JSONDecoder {
        switch self {
        case .getRepository:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
            
        case .getDetails:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
    }
    
}
