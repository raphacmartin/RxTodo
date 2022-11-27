//
//  BaseViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/27/22.
//

import UIKit

public class BaseViewController: UIViewController {
    private let background = UIView()
    
    public func showLoading() {
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
    
    public func hideLoading() {
        background.removeFromSuperview()
    }
}
