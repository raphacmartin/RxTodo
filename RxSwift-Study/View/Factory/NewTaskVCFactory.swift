//
//  NewTaskVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 20/01/23.
//

import UIKit

final class NewTaskVCFactory: ViewControllerFactoring {
    public static func make() -> NewTaskViewController {
        let apiUrl = Environment.apiUrl
        let todoApiClient = TodoAPIClient(baseURL: apiUrl)
        let service = TaskService(apiClient: todoApiClient)
        let viewModel = NewTaskViewModel(taskService: service)
        return NewTaskViewController(viewModel: viewModel)
    }   
}
