//
//  UIViewController+Helper.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/23/22.
//

import UIKit

extension UIViewController {
    public func showAlert(withMessage message: String, withTitle title: String = "Attention!") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            alert?.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
}
