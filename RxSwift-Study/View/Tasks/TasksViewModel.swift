//
//  TasksViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 08/01/23.
//

import RxCocoa
import RxSwift

enum TaskResponse {
    case success(Task)
    case error(Error)
}

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
        let reloadTasks: Observable<Void>
    }
    
    struct Output {
        let tasks: Driver<[Task]>
        let taskCompleted: Driver<TaskResponse>
        let taskDeleted: Driver<Task>
    }
    
    
    func connect(input: Input) -> Output {
        let taskCompleted = input.completeTask
            .flatMap { task in
                self.taskService.rx.update(task: task)
                    .asObservable()
                    .map { TaskResponse.success($0) }
                    .catch { error in
                        return Observable.just(.error(error))
                    }
            }
        
        let taskDeleted = input.deleteTask
//            .flatMap { task in
//                // TODO: Call service method
//            }
        
        let tasks = input.reloadTasks
            .flatMapLatest { [taskService] _ in
                return taskService.rx.getAll()
            }
        
        let task = Task(id: "", dueDate: Date(), description: "", completed: false)
        
        return Output(
            tasks: tasks.asDriver(onErrorJustReturn: []),
            taskCompleted: taskCompleted.asDriver(onErrorJustReturn: .error(APIError.systemError("Error on updating task"))),
            taskDeleted: taskDeleted.asDriver(onErrorJustReturn: task)
        )
    }
}
