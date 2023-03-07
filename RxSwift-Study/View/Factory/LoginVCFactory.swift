//
//  LoginVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/22/22.
//

import UIKit

final class LoginVCFactory: ViewControllerFactoring {
    public static func make() -> LoginViewController {
        let apiUrl = Environment.apiUrl
        let todoApiClient = TodoAPIClient(baseURL: apiUrl)
        let userService = UserService(apiClient: todoApiClient)
        let viewModel = LoginViewModel(userService: userService)
        
        return LoginViewController(viewModel: viewModel)
    }
}
