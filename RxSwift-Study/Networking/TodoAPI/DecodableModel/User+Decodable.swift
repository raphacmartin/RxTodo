//
//  CodableUser.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/21/22.
//

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.username = try container.decode(String.self, forKey: .username)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case username
    }
}
