//
//  LoginVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/22/22.
//

import UIKit

class LoginVCFactory: ViewControllerFactoring {
    public static func make() -> LoginViewController {
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as? String, let apiUrl = URL(string: apiUrl) else {
            fatalError("Unable to read the API URL from the Info.plist file")
        }
        let todoApiClient = TodoAPIClient(baseURL: apiUrl)
        let userService = UserService(apiClient: todoApiClient)
        
        return LoginViewController(userService: userService)
    }
}
