//
//  TaskEndpoint.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 05/01/23.
//

class TasksEndpoint {
    struct GetTasks: Endpoint {
        var path: String = "/tasks"
        
        var method: HTTPMethod {
            .GET
        }
    }
    
    struct Update: Endpoint{
        var path: String {
            guard let taskId = task.id else {
                fatalError("Trying to update task without id")
            }
            return "/tasks/\(taskId)"
        }
        
        var method: HTTPMethod {
            .PATCH
        }
        
        var task: Task
        
        var bodyParameters: [String : Any?]? {
            [
                "dueDate": task.dueDate.toJson(),
                "description": task.description,
                "completed": task.completed
            ]
        }
    }
    
    struct Add: Endpoint{
        var path: String {
            "/tasks"
        }
        
        var method: HTTPMethod {
            .POST
        }
        
        var task: Task
        
        var bodyParameters: [String : Any?]? {
            [
                "dueDate": task.dueDate.toJson(),
                "description": task.description,
                "completed": task.completed
            ]
        }
    }
}
