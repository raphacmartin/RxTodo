//
//  TasksViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 08/01/23.
//

import RxCocoa
import RxSwift

final class TasksViewModel {
    let taskService: TaskService
    
    init(taskService: TaskService) {
        self.taskService = taskService
    }
}

// MARK: ViewModel conformity
extension TasksViewModel: ViewModel {
    struct Input {
        let completeTask: Observable<Task>
        let deleteTask: Observable<Task>
    }
    
    struct Output {
        let loadTasks: Driver<[Task]>
        let taskCompleted: Driver<Task>
        let taskDeleted: Driver<Task>
    }
    
    
    func connect(input: Input) -> Output {
        let taskCompleted = input.completeTask
//            .flatMap { task in
//                // TODO: Call service method
//            }
        let taskDeleted = input.deleteTask
//            .flatMap { task in
//                // TODO: Call service method
//            }
        
        let task = Task(id: "", dueDate: Date(), description: "", completed: false)
        
        return Output(
            loadTasks: taskService.rx.getAll().asDriver(onErrorJustReturn: []),
            taskCompleted: taskCompleted.asDriver(onErrorJustReturn: task),
            taskDeleted: taskDeleted.asDriver(onErrorJustReturn: task)
        )
    }
}
