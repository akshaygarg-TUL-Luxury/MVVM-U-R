//
//  Networking.swift
//  GithubSearch
//
//  Created by Akshay Garg on 28/04/22.
//

import Foundation

class NetworkManager<Target> where Target: TargetType {
    func request<T: Decodable>(for target: Target, completion: @escaping (Result<T, Error>) -> Void) {
        var urlString = target.baseUrl + target.endpoint + "?"
        target.parameters.forEach { (key, value) in
            urlString += "\(key)=\(value)"
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        target.headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let model = try target.decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
