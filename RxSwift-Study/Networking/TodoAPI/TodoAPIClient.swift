//
//  TodoAPIClient.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

import Foundation

final class TodoAPIClient: APIClient {
    // MARK: Properties
    let baseURL: URL
    let authManager: AuthManaging
    
    // MARK: Initializer
    init(baseURL: URL, authManager: AuthManaging = AuthManager.shared) {
        self.baseURL = baseURL
        self.authManager = authManager
    }
    
    func request(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask {
        
        var url = baseURL
        url.appendPathComponent(endpoint.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let bearerToken = authManager.bearerToken {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let parameters = endpoint.bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }

        task.resume()

        return task
    }
    
    
}
