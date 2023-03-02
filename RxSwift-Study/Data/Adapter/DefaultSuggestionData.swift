//
//  DefaultSuggestionData.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 15/02/23.
//

import RxSwift

final class DefaultSuggestionData: SuggestionData {
    var suggestions: Observable<[String]> {
        Observable.just([
            "Do the laundry",
            "Feed the dog",
            "Do the homework",
            "Go to gym",
            "Read one chapter of the book"
        ])
    }
}
