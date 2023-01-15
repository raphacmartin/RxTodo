//
//  Task+Decodable.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 05/01/23.
//

import Foundation

extension Task: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.dueDate = try container.decode(Date.self, forKey: .dueDate)
        self.description = try container.decode(String.self, forKey: .description)
        self.completed = try container.decode(Bool.self, forKey: .completed)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dueDate
        case description
        case completed
    }
}
