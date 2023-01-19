//
//  Endpoint.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}

protocol Endpoint {
    var path: String { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
    var bodyParameters: [String: Any?]? { get }
}

extension Endpoint {
    var headers: [String: String]? {
        nil
    }
    
    var bodyParameters: [String: Any?]? {
        nil
    }
}
