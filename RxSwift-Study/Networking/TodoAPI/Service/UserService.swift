//
//  UserService.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

import Foundation

class UserService {
    // MARK: Private properties
    private let apiClient: APIClient
    private var authManager: AuthManaging

    init(apiClient: APIClient, authManager: AuthManaging = AuthManager.shared) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
}


// MARK: Service methods
extension UserService {
    @discardableResult
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) -> URLSessionTask {
        let endpoint = UserEndpoint.Login(email: email, password: password)

        return apiClient.request(from: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let (user, token) = self?.decodeResponse(data: data) else {
                    completion(.failure(APIError.invalidData))
                    return
                }

                self?.authManager.bearerToken = token

                DispatchQueue.main.async {
                    completion(.success(user))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func register(firstName: String, lastName: String, email: String, username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) -> URLSessionTask {
        let endpoint = UserEndpoint.Register(firstName: firstName, lastName: lastName, email: email, username: username, password: password)

        return apiClient.request(from: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let (user, token) = self?.decodeResponse(data: data) else {
                    completion(.failure(APIError.invalidData))
                    return
                }

                self?.authManager.bearerToken = token

                DispatchQueue.main.async {
                    completion(.success(user))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: Private API
extension UserService {
    private func decodeResponse(data: Data) -> (user: User, token: String?)? {
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        
        var token: String?
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            token = jsonObject["token"] as? String
        }

        return (user: user, token: token)
    }
}
