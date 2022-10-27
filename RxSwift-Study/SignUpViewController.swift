//
//  SignUpViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/27/22.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    // MARK: UI Components
    private var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private var registerButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var passwordLengthLabel: UILabel = {
        var label = UILabel()
        label.text = "Password must contain 3 to 16 characters"
        label.numberOfLines = 0
        return label
    }()
    
    private var passwordNumbersLabel: UILabel = {
        var label = UILabel()
        label.text = "Password must contain at least one number"
        label.numberOfLines = 0
        return label
    }()
    
    private var passwordMatchLabel: UILabel = {
        var label = UILabel()
        label.text = "Password and password confirmation must match"
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Layout constants
    private let horizontalMargin = 20.0
    
    // MARK: Rx Properties
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        
        view.backgroundColor = .white
        
        Observable.combineLatest(passwordTextField.rx.text.orEmpty, confirmPasswordTextField.rx.text.orEmpty)
            .map { [unowned self] password, passwordConfirmation in
                return (
                    self.checkLength(of: password),
                    self.checkNumbersExistence(in: password),
                    self.checkEquality(of: password, and: passwordConfirmation)
                )
            }
            .subscribe(onNext: { [weak self] isLengthValid, hasNumbers, passwordAndConfirmationMatches in
                self?.passwordLengthLabel.textColor = isLengthValid ? .green : .red
                self?.passwordNumbersLabel.textColor = hasNumbers ? .green : .red
                self?.passwordMatchLabel.textColor = passwordAndConfirmationMatches ? .green : .red
                
                self?.registerButton.isEnabled = isLengthValid && hasNumbers && passwordAndConfirmationMatches
            })
            .disposed(by: disposeBag)
            
    }
}

// MARK: View Code
extension SignUpViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            usernameTextField,
            passwordTextField,
            confirmPasswordTextField,
            registerButton,
            passwordLengthLabel,
            passwordNumbersLabel,
            passwordMatchLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
    
    
}

// MARK: Private API
extension SignUpViewController {
    private func checkLength(of password: String) -> Bool {
        return 3...16 ~= password.count
    }
    
    private func checkNumbersExistence(in password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    private func checkEquality(of password: String, and passwordConfirmation: String) -> Bool {
        return !password.isEmpty && password == passwordConfirmation
    }
}
