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
    private let taskService: TaskService
    private var suggestionsData: SuggestionData
    private let disposeBag = DisposeBag()
    
    init(taskService: TaskService) {
        self.taskService = taskService
        self.suggestionsData = DefaultSuggestionData()
    }
}

// MARK: ViewModel conformity
extension NewTaskViewModel: ViewModel {
    struct Input {
        let description: Observable<String>
        let addTask: Observable<Task?>
    }
    
    struct Output {
        let suggestions: Driver<[String]>
        let shouldShowDefaultTitle: Driver<Bool>
        let shouldEnableAddButton: Driver<Bool>
        let taskAdded: Driver<TaskResponse>
    }
    
    func connect(input: Input) -> Output {
        let suggestions = input.description
            .flatMapSorted(initialValue: [String](), { [weak self] description -> Observable<[String]> in
                guard let self = self else {
                    return Observable.error(APIError.systemError("Nil self"))
                }
                
                if description.count >= 3 {
                    self.suggestionsData = APISuggestionData(service: self.taskService, term: description)
                } else {
                    self.suggestionsData = DefaultSuggestionData()
                }
                
                return self.suggestionsData.suggestions
            })
        
        let shouldShowDefaultTitle = input.description
            .map { $0.count < 3 }
        
        let shouldEnableAddButton = input.description
            .map { $0.count >= 3 }
        
        let taskAdded = input.addTask
            .withLatestFrom(input.description) { ($0, $1) }
            .flatMapLatest { [taskService] task, taskDescription in
                let service: Single<Task>
                if var task = task {
                    task.description = taskDescription
                    service = taskService.rx.update(task: task)
                } else {
                    let task = Task(dueDate: Date(), description: taskDescription, completed: false)
                    service = taskService.rx.add(task: task)
                }

                return service
                    .asObservable()
                    .map { TaskResponse.success($0) }
                    .catch { Observable.just(.error($0)) }
            }
        
        return Output(
            suggestions: suggestions.asDriver(onErrorJustReturn: []),
            shouldShowDefaultTitle: shouldShowDefaultTitle.asDriver(onErrorJustReturn: true),
            shouldEnableAddButton: shouldEnableAddButton.asDriver(onErrorJustReturn: false),
            taskAdded: taskAdded.asDriver(onErrorJustReturn: .error(APIError.systemError("Error on adding task"))))
    }
}
