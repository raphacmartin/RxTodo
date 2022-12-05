//
//  LoginViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 12/3/22.
//

import RxCocoa
import RxSwift
import RxSwiftExt

enum LoginResponse {
    case loggedIn(User)
    case unauthorized
    case error(Error)
}

final class LoginViewModel {
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    private func isUnauthorized(_ error: Error) -> Bool {
        if let error = error as? APIError, case .httpError(let statusCode) = error, statusCode == 401 {
            return true
        }
        return false
    }
}

// MARK: ViewModel conformity
extension LoginViewModel: ViewModel {
    struct Input {
        let credentials: Observable<(String, String)>
        let loginTapButtonEvent: Observable<Void>
    }
    
    struct Output {
        let login: Driver<LoginResponse>
        let shouldEnableLoginButton: Driver<Bool>
        let showLoading: Driver<Bool>
    }
    
    func connect(input: Input) -> Output {
        let login = input.loginTapButtonEvent
            .withLatestFrom(input.credentials)
            .flatMapLatest { [userService] username, password in
                return userService.rx.login(email: username, password: password)
                    .asObservable()
                    .map { LoginResponse.loggedIn($0) }
                    .catch { [weak self] error in
                        guard let self = self, self.isUnauthorized(error) else {
                            return Observable.just(.error(error))
                        }
                        
                        return Observable.just(.unauthorized)
                    }
            }
        
        let shouldEnableLoginButton = input.credentials
            .map { username, password in
                !username.isEmpty && !password.isEmpty
            }
        
        let showLoading = Observable.merge(input.loginTapButtonEvent.mapTo(true), login.mapTo(false))
        
        return Output(
            login: login.asDriver(onErrorJustReturn: .error(APIError.systemError("Error on login"))),
            shouldEnableLoginButton: shouldEnableLoginButton.asDriver(onErrorJustReturn: false),
            showLoading: showLoading.asDriver(onErrorJustReturn: false))
    }
}
