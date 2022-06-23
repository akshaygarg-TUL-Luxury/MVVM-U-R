//
//  SearchRepoTarget.swift
//  GithubSearch
//
//  Created by Akshay Garg on 29/04/22.
//

import Alamofire
import Foundation

enum SearchRepoTarget {
    case getRepository(searchText: String)
    case updateUser
    case editUser
    case uploadImage
}

extension SearchRepoTarget: TargetType {
    var baseUrl: String {
        switch self {
        case .getRepository, .updateUser, .editUser:
            return "https://gorest.co.in/public"
        case .uploadImage:
            return "https://api.kraken.io"
        }
    }
    
    var endpoint: String {
        switch self {
        case .getRepository:
            return "/v2/users"
        case .updateUser:
            return "/v2/users"
        case .editUser:
            return "/v2/users/9672"
        case .uploadImage:
            return "/v1/upload"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRepository:
            return .get
        case .updateUser, .uploadImage:
            return .post
        case .editUser:
            return .put
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getRepository, .updateUser, .editUser:
            return [
//                "Accept": "application/json",
                "Authorization": "Bearer ed75d4ea4b4ba1f42a1b9f54d02a40b6603cf623de7eb807f8ab22c749916b4d"
            ]
        case .uploadImage:
            return [:
//                "x-api-key": "8bae62c1-8393-4e9e-8ac1-9b9a8c470aea",
//                "Content-Type": "multipart/form-data"
            ]
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getRepository:
            return [:
//                "size": "medium",
//                "limit": "30",
//                "format": "src",
//                "breed_id": searchText
            ]
            
        case .updateUser:
            return [
                "name": "Akshay Garg",
                "email": "agarg@test.com",
                "gender": "male",
                "status": "active"
            ]
            
        case .editUser:
            return [
                "name": "Don Corleone",
                "email": "agarg@test.com",
                "gender": "male",
                "status": "active"
            ]
        case .uploadImage:
            return [
//                "file": "file",
//                "sub_id": "",
//                "width": "500"
                "data": "{\"auth\":{\"api_key\": \"15fa7b801ad14a6186e97cc1de4dc722\", \"api_secret\": \"ae12318b5ef1f3cef8d7a9d23cdddc348b3d5121\"}, \"wait\":true}"
            ]
        }
    }
}
