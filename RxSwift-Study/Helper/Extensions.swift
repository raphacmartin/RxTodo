//
//  Extensions.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 19/01/23.
//

import Foundation

extension Date {
    func toJson() -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        return dateFormatter.string(from: self)
    }
}
