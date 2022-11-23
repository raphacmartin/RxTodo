//
//  UserEndpoint.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

class UserEndpoint {
    fileprivate static let basePath = "/users"
    
    struct Login {
        let email: String
        let password: String
    }
    
    struct Register {
        let firstName: String
        let lastName: String
        let email: String
        let username: String
        let password: String
    }
    
}


// MARK: Endpoint conformance
extension UserEndpoint.Login: Endpoint {
    var path: String {
        "\(UserEndpoint.basePath)/login"
    }
    
    var headers: [String : String]? {
        let authData = (email+":"+password).data(using: .utf8)!.base64EncodedString()
        return ["Authorization": "Basic \(authData)"]
    }
    
    var method: HTTPMethod {
        .POST
    }
}

extension UserEndpoint.Register: Endpoint {
    var path: String {
        "\(UserEndpoint.basePath)/register"
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var bodyParameters: [String : Any?]? {
        [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "username": username,
            "password": password
        ]
    }
}
