//
//  SignUpVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/27/22.
//

import UIKit

class SignUpVCFactory: ViewControllerFactoring {
    public static func make() -> SignUpViewController {
        let apiUrl = Environment.apiUrl
        let todoApiClient = TodoAPIClient(baseURL: apiUrl)
        let userService = UserService(apiClient: todoApiClient)
        let viewModel = SignUpViewModel(userService: userService)
        
        return SignUpViewController(viewModel: viewModel)
    }
    
    
}
