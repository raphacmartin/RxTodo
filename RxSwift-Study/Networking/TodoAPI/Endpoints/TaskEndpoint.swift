//
//  TaskEndpoint.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 05/01/23.
//

class TasksEndpoint {
    struct GetTasks: Endpoint {
        var path: String = "/tasks"
        
        var method: HTTPMethod = .GET
    }
}
