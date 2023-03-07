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
    ///
    /// Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence, ensuring that concurrent executions of observable sequences happens, but producing values only from the most recent observable sequence.
    ///
    /// - parameter initialValue: A value to be compared with first emitted event
    /// - parameter selector: A transform function to apply to each element.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
    func flatMapSorted<Source: ObservableConvertibleType>(initialValue: Source.Element, _ selector: @escaping (Element) throws -> Source)
    -> Observable<Source.Element> {
        typealias IndexedEvent = (index: Int, value: Source.Element)
        
        return self
            .enumerated()
            .flatMap { index, element -> Observable<IndexedEvent> in
                return try! selector(element)
                    .asObservable()
                    .map { element in
                        return IndexedEvent(index: index, value: element)
                    }
            }
            .scan((0, initialValue), accumulator: { prev, next in
                // return the event with the higher index
                next.index >= prev.index ? next : prev
            })
            .map { $0.value }
    }
}
