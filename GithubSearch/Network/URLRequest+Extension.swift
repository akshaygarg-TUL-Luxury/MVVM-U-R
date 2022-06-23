//
//  URLRequest+Extension.swift
//  GithubSearch
//
//  Created by Akshay Garg on 07/05/22.
//

import Alamofire
import Foundation

extension URLRequest: URLConvertible {
    public func asURL() throws -> URL {
        if let url = url {
            return url
        }
        throw AFError.invalidURL(url: self)
    }
}
