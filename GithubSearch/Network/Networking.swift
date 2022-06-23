//
//  Networking.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Alamofire
import Combine
import Foundation
import UIKit

/*
 1. token exist -> actual API
 2. token expired -> refresh token with default logic -> actual API
 3. no refresh token needed
 4. expired token -> refresh token logic by DI
 */

protocol TokenRefresher {
    func refreshToken()
}

class DefaultTokenRefresher: TokenRefresher {
    func refreshToken() {
        
    }
}


final class NetworkManager<Target> where Target: TargetType {
    
    let shouldRefresh: Bool
    let refresher: TokenRefresher
    
    init(shouldRefresh: Bool = true, refresher: TokenRefresher = DefaultTokenRefresher()) {
        self.shouldRefresh = shouldRefresh
        self.refresher = refresher
    }
    
    func request(for target: Target) -> DataRequest {
        let urlString = target.baseUrl + target.endpoint

        print("===> network call with request: \(urlString)")

        return AF
            .request(urlString, method: target.method, parameters: target.parameters, headers: HTTPHeaders(target.headers))
            .validate()
    }
    
    func upload(image: UIImage, fileName: String, for target: Target) -> DataRequest {
        let urlString = target.baseUrl + target.endpoint
        
        return AF.upload(
            multipartFormData: { multipartFormData in
                target.parameters
                    .convertValuesToData()
                    .forEach { (key, value) in
                        multipartFormData.append(value, withName: key)
                    }
                
                if let data = image.pngData() {
                    multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "image/png")
                }
            },
            to: urlString,
            method: target.method,
            headers: HTTPHeaders(target.headers))
            .validate()
    }
}

extension Dictionary where Key == String, Value == String {
    func convertValuesToData() -> [(key: String, value: Data)] {
        return self.compactMap({ (key, value) -> (key: String, value: Data)? in
            if let data = value.data(using: .utf8) {
                return (key, data)
            }
            return nil
        })
    }
}
