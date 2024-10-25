//
//  AuthManager.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/19/22.
//

final class AuthManager: AuthManaging {
    var bearerToken: String?
    
    // MARK: Singleton
    public static let shared = AuthManager()
    private init() { }
}
