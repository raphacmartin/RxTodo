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
    
    func update(task: Task) -> Single<Task> {
        Single.create { single in
            let networkTask = base.update(task: task) { result in
                single(result)
            }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
    
    func add(task: Task) -> Single<Task> {
        Single.create { single in
            let networkTask = base.add(task: task) { result in
                single(result)
            }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
    
    func delete(task: Task) -> Single<Task> {
        Single.create { single in
            let networkTask = base.delete(task: task) { result in
                single(result)
            }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
    
    func getSuggestions(with term: String) -> Single<[String]> {
        Single.create { single in
            let networkTask = base.getSuggestions(with: term) { result in
                single(result)
            }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
}
