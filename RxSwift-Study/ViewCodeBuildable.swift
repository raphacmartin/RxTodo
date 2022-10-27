//
//  ViewCodeBuildable.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/27/22.
//

protocol ViewCodeBuildable {
    func setupHierarchy()
    func setupConstraints()
}

extension ViewCodeBuildable {
    func buildView() {
        setupHierarchy()
        setupConstraints()
    }
}
