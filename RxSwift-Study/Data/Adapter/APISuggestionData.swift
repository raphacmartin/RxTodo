//
//  APISuggestionData.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 17/02/23.
//

import RxSwift

class APISuggestionData: SuggestionData {
    // MARK: Private properties
    private var service: TaskService
    private var term: String
    
    // MARK: Public properties
    var suggestions: Observable<[String]> {
        service.rx.getSuggestions(with: term)
            .asObservable()
    }
    
    // MARK: Initializer
    init(service: TaskService, term: String) {
        self.service = service
        self.term = term
    }
}
