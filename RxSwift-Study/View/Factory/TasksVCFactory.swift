//
//  TasksVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 04/01/23.
//

import UIKit

class TasksVCFactory: ViewControllerFactoring {
    public static func make() -> TasksViewController {
        let apiUrl = Environment.apiUrl
        let todoApiClient = TodoAPIClient(baseURL: apiUrl)
        let service = TaskService(apiClient: todoApiClient)
        let viewModel = TasksViewModel(taskService: service)
        
        return TasksViewController(viewModel: viewModel)
    }
}
