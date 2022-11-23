//
//  UserService+Rx.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

import Foundation
import RxSwift

extension UserService: ReactiveCompatible { }

extension Reactive where Base: UserService {
    func login(email: String, password: String) -> Single<User> {
        Single.create { single in
            let networkTask = base.login(email: email, password: password) { result in
                single(result)
            }

            return Disposables.create {
                networkTask.cancel()
            }
        }
    }

    func register(firstName: String, lastName: String, email: String, username: String, password: String) -> Observable<User> {
        Observable.create { observer in
            let networkTask = base.register(firstName: firstName, lastName: lastName, email: email, username: username, password: password) { result in
                switch result {
                case .success(let user):
                    observer.onNext(user)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
}
