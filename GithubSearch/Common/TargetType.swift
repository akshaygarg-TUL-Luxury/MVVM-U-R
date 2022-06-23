//
//  TargetType.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Alamofire
import Foundation

protocol TargetType {
    var baseUrl: String { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
}
