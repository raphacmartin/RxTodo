//
//  APIClient.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/19/22.
//

import Foundation

enum APIError: Error {
    case invalidData
    case networkError(Error)
}

protocol APIClient {
    var baseURL: URL { get }
    var authManager: AuthManaging { get }
    
    func request(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask
}
