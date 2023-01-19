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
    
    struct Update: Endpoint{
        var path: String {
            "/tasks/\(task.id)"
        }
        
        var method: HTTPMethod = .PATCH
        
        var task: Task
        
        var bodyParameters: [String : Any?]? {
            [
                // TODO:
                "dueDate": task.dueDate.toJson(),
                "description": task.description,
                "completed": task.completed
            ]
        }
    }
}
