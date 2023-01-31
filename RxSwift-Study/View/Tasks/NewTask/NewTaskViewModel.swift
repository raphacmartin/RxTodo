//
//  NewTaskViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 22/01/23.
//

import RxCocoa
import RxSwift

final class NewTaskViewModel {
    // MARK: Private properties
    let taskService: TaskService
    
    init(taskService: TaskService) {
        self.taskService = taskService
    }
}

// MARK: ViewModel conformity
extension NewTaskViewModel: ViewModel {
    struct Input {
        let description: Observable<String>
        let addTask: Observable<Void>
    }
    
    struct Output {
        let shouldEnableAddButton: Driver<Bool>
        let taskAdded: Driver<TaskResponse>
    }
    
    func connect(input: Input) -> Output {
        let shouldEnableAddButton = input.description
            .map { $0.count >= 3 }
        
        let taskAdded = input.addTask
            .withLatestFrom(input.description)
            .flatMapLatest { [taskService] taskDescription in
                let task = Task(dueDate: Date(), description: taskDescription, completed: false)
                
                return taskService.rx.add(task: task)
                    .asObservable()
                    .map { TaskResponse.success($0) }
                    .catch { Observable.just(.error($0)) }
            }
        
        return Output(shouldEnableAddButton: shouldEnableAddButton.asDriver(onErrorJustReturn: false), taskAdded: taskAdded.asDriver(onErrorJustReturn: .error(APIError.systemError("Error on adding task"))))
    }
}
