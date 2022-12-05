//
//  BaseViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/27/22.
//

import UIKit
import RxRelay
import RxSwift

public class BaseViewController: UIViewController {
    // MARK: Public properies
    public var isLoadingVisible = BehaviorRelay<Bool>(value: false)
    
    // MARK: Private properies
    private let disposeBag = DisposeBag()
    private let background = UIView()
    
    // MARK: Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
}

// MARK: Private API
extension BaseViewController {
    private func setupObservers() {
        isLoadingVisible.subscribe(onNext: { [weak self] isVisible in
            if isVisible {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func showLoading() {
        background.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.center = background.center
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.color = .black
        background.addSubview(loadingIndicator)
        
        view.addSubview(background)
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        background.removeFromSuperview()
    }
}
