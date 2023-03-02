//
//  SuggestionData.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 13/02/23.
//

import RxSwift

protocol SuggestionData {
    var suggestions: Observable<[String]> { get }
}
