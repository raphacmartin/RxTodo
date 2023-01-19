//
//  TaskService.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 05/01/23.
//

import Foundation

class TaskService {
    // MARK: Private properties
    private let apiClient: APIClient
    private var authManager: AuthManaging

    init(apiClient: APIClient, authManager: AuthManaging = AuthManager.shared) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
}

// MARK: Service methods
extension TaskService {
    public func getAll(completion: @escaping (Result<[Task], Error>) -> Void) -> URLSessionTask {
        let endpoint = TasksEndpoint.GetTasks()
        
        return apiClient.request(from: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let tasks = self?.decodeListResponse(data: data) else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func update(task: Task, completion: @escaping (Result<Task, Error>) -> Void) -> URLSessionTask {
        let endpoint = TasksEndpoint.Update(task: task)
        
        return apiClient.request(from: endpoint) { result in
            switch result {
            case .success(let data):
                guard let task = self.decodeTaskResponse(data: data) else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: Private API
extension TaskService {
    private func decodeListResponse(data: Data) -> [Task]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let task = try? decoder.decode([Task].self, from: data) else {
            
            if let jsonData = String(data: data, encoding: .utf8) {
                print("Error decoding data to array of tasks: ")
                print(jsonData)
            }
            
            return nil
        }
        
        return task
    }
    
    private func decodeTaskResponse(data: Data) -> Task? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let task = try? decoder.decode(Task.self, from: data) else {
            
            if let jsonData = String(data: data, encoding: .utf8) {
                print("Error decoding data to a task: ")
                print(jsonData)
            }
            
            return nil
        }
        
        return task
    }
}
