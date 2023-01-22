//
//  NewTaskVCFactory.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 20/01/23.
//

import UIKit

final class NewTaskVCFactory: ViewControllerFactoring {
    public static func make() -> NewTaskViewController {
        let viewModel = NewTaskViewModel()
        return NewTaskViewController(viewModel: viewModel)
    }   
}
