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
    // MARK: Private properties
    let userService: UserService
    
    // MARK: Initializer
    init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: UI Components
    private var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
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
        
        _setupBindings()
    }
}

// MARK: View Code methods
extension LoginViewController: ViewCodeBuildable {
    func setupHierarchy() {
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
    private func _setupBindings() {
        let credentials = Observable.combineLatest(
            usernameTextField.rx.text.orEmpty.asObservable(),
            passwordTextField.rx.text.orEmpty.asObservable())
        
        credentials
        .map { username, password -> Bool in
            return !username.isEmpty && !password.isEmpty
        }
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .withLatestFrom(credentials)
            .flatMapLatest { [userService] username, password in
                userService.rx.login(email: username, password: password)
                    .asObservable()
                    .catch { error in
                        return .empty()
                    }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                
                // TODO: Go to task view
                let alert = UIAlertController(title: "Login", message: "You are logged in :)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
                    alert?.dismiss(animated: true)
                }))
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
