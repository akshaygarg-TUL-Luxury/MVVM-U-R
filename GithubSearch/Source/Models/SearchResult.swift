//
//  SearchResult.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation

struct SearchResult: Decodable {
    let items: [Repository]
}

struct Repository: Decodable {
    let id: Int
    let name: String
    let full_name: String
    let html_url: URL
    let description: String?
    let created_at: Date
    let watchers: Int
}

struct ViewRepositiry {
    let full_name: String
    let html_url: URL
}


struct RepoDetails: Decodable {
    let id: String
    let name: String
}
