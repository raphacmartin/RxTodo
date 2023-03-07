//
//  SignUpViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 12/11/22.
//

import RxCocoa
import RxSwift
import UIKit

enum SignupResponse {
    case signedUp
    case error(Error)
}

final class SignUpViewModel {
    public let minimumValidPasswordLength = 6
    public let maximumValidPasswordLength = 16
    
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
}

// MARK: ViewModel conformity
extension SignUpViewModel: ViewModel {
    struct Input {
        let firstName: Observable<String>
        let lastName: Observable<String>
        let email: Observable<String>
        let username: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let registerTapButtonEvent: Observable<Void>
    }
    
    struct Output {
        let isPasswordLengthValid: Driver<Bool>
        let passwordHaveNumbers: Driver<Bool>
        let passwordsMatch: Driver<Bool>
        let shouldEnableRegisterButton: Driver<Bool>
        let showLoading: Driver<Bool>
        let register: Driver<SignupResponse>
    }
    
    func connect(input: Input) -> Output {
        let isPasswordLengthValid = input.password.map(self.checkLength(of:))
        
        let passwordHaveNumbers = input.password.map(self.checkNumbersExistence(in:))
        
        let passwordsMatch = Observable.combineLatest(input.password, input.confirmPassword).map(self.checkEquality)
        
        let allFieldsFilled = Observable.combineLatest(
            input.firstName,
            input.lastName,
            input.email,
            input.username
        )
            .map { firstName, lastName, email, username in
                return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !username.isEmpty
            }
        
        let shouldEnableRegisterButton = Observable.combineLatest(
            isPasswordLengthValid,
            passwordHaveNumbers,
            passwordsMatch,
            allFieldsFilled
        )
            .map { $0 && $1 && $2 && $3 }
        
        let fields = Observable.combineLatest(
            input.firstName,
            input.lastName,
            input.email,
            input.username,
            input.password
        )
        
        let register = input.registerTapButtonEvent
            .withLatestFrom(fields)
            .flatMapLatest({ [userService] firstName, lastName, email, username, password in
                return userService.rx.register(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    username: username,
                    password: password)
                .asObservable()
                .map { _ in SignupResponse.signedUp }
                .catch { Observable.just(SignupResponse.error($0)) }
            })
        
        let showLoading = Observable.merge(input.registerTapButtonEvent.mapTo(true), register.mapTo(false))
        
        return Output(
            isPasswordLengthValid: isPasswordLengthValid.asDriver(onErrorJustReturn: false),
            passwordHaveNumbers: passwordHaveNumbers.asDriver(onErrorJustReturn: false),
            passwordsMatch: passwordsMatch.asDriver(onErrorJustReturn: false),
            shouldEnableRegisterButton: shouldEnableRegisterButton.asDriver(onErrorJustReturn: false),
            showLoading: showLoading.asDriver(onErrorJustReturn: false),
            register: register.asDriver(onErrorJustReturn: .error(APIError.systemError("Error on signup")))
        )
    }
}

// MARK: Private API
extension SignUpViewModel {
    private func checkLength(of password: String) -> Bool {
        return minimumValidPasswordLength...maximumValidPasswordLength ~= password.count
    }
    
    private func checkNumbersExistence(in password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    private func checkEquality(of password: String, and passwordConfirmation: String) -> Bool {
        return !password.isEmpty && password == passwordConfirmation
    }
}

