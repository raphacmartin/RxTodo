//
//  Extensions.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 19/01/23.
//

import Foundation
import RxSwift

extension Date {
    func toJson() -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        return dateFormatter.string(from: self)
    }
}

extension Observable {
    func flatMapSorted<Source: ObservableConvertibleType>(initialValue: Source.Element, _ selector: @escaping (Element) throws -> Source)
    -> Observable<Source.Element> {
        return self
            .enumerated()
            .flatMap { index, element -> Observable<(Int, Source.Element)> in
                return try! selector(element)
                    .asObservable()
                    .map { element in
                        return (index, element)
                    }
            }
            .scan((-1, initialValue), accumulator: { prev, next in
                // return the event with the higher index
                return [prev, next].max { a, b in a.0 < b.0 }!
            })
            .map { $0.1 }
    }
}
