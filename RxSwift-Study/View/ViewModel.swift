//
//  ViewModel.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 12/3/22.
//

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func connect(input: Input) -> Output
}
