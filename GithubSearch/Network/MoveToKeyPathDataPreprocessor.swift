//
//  MoveToKeyPathDataPreprocessor.swift
//  GithubSearch
//
//  Created by Akshay Garg on 07/05/22.
//

import Alamofire
import Foundation

struct MoveToKeyPathDataPreprocessor: DataPreprocessor {
    let keyPath: String
    func preprocess(_ data: Data) throws -> Data {
        if keyPath.isEmpty {
            return data
        }
        return try map(data: data, atKeyPath: keyPath)
    }
    
    private func mapJSON(data: Data) throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
    
    private func map(data: Data, atKeyPath keyPath: String) throws -> Data {
        let serializeToData: (Any) throws -> Data? = { (jsonObject) in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
        }
        
        guard let jsonObject = (try mapJSON(data: data) as? NSDictionary)?.value(forKeyPath: keyPath) else {
            throw AFError.responseSerializationFailed(reason: .inputFileNil)
        }
        
        if let data = try serializeToData(jsonObject) {
            return data
        }
        let wrappedJsonObject = ["value": jsonObject]
        let wrappedJsonData: Data
        if let data = try serializeToData(wrappedJsonObject) {
            wrappedJsonData = data
        } else {
            throw AFError.responseSerializationFailed(reason: .inputFileNil)
        }
        return wrappedJsonData
    }
}
