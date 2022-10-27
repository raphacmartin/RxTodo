//
//  ViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
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
    
    private var loginButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var signUpButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Sign Up", for: .normal)
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
    
    // MARK: Layout constants
    private let horizontalMargin = 20.0
    
    // MARK: Rx Properties
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buildView()
        
        Observable.combineLatest(
            usernameTextField.rx.text.orEmpty,
            passwordTextField.rx.text.orEmpty)
        .map { username, password -> Bool in
            return !username.isEmpty && !password.isEmpty
        }
        .subscribe(onNext: { [weak self] bothFieldsFilled in
            self?.loginButton.isEnabled = bothFieldsFilled
        })
        .disposed(by: disposeBag)
    }
}

// MARK: View Code methods
extension LoginViewController: ViewCodeBuildable {
    func setupHierarchy() {
        signUpButton.addTarget(self, action: #selector(self.goToSignup), for: .touchUpInside)
        
        [usernameTextField,
         passwordTextField,
         loginButton,
         signUpButton]
            .forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
}

// MARK: Private API
extension LoginViewController {
    @objc func goToSignup() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
