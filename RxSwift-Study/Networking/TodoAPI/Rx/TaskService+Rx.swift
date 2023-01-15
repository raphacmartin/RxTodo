//
//  TaskService+Rx.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 08/01/23.
//

import RxSwift

extension TaskService: ReactiveCompatible { }

extension Reactive where Base: TaskService {
    func getAll() -> Single<[Task]> {
        Single.create { single in
            let networkTask = base.getAll { result in
                single(result)
            }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
}
