//
//  ViewFactoring.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/22/22.
//

import UIKit

protocol ViewControllerFactoring {
    associatedtype ViewControllerType: UIViewController
    
    static func make() -> ViewControllerType
}
