//
//  SignUpViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/27/22.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let minimumValidPasswordLength = 6
fileprivate let maximumValidPasswordLength = 16

class SignUpViewController: UIViewController {
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
    private var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
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
        label.text = "Password must contain \(minimumValidPasswordLength) to \(maximumValidPasswordLength) characters"
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
        
        _setupBindings()
    }
}

// MARK: View Code
extension SignUpViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            firstNameTextField,
            lastNameTextField,
            emailTextField,
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
    private func _setupBindings() {
        let fields = Observable.combineLatest(
            firstNameTextField.rx.text.orEmpty.asObservable(),
            lastNameTextField.rx.text.orEmpty.asObservable(),
            emailTextField.rx.text.orEmpty.asObservable(),
            usernameTextField.rx.text.orEmpty.asObservable(),
            passwordTextField.rx.text.orEmpty.asObservable(),
            confirmPasswordTextField.rx.text.orEmpty.asObservable())
        
        fields
            .map { [unowned self] firstName, lastName, email, username, password, passwordConfirmation in
                return (
                    !firstName.isEmpty,
                    !lastName.isEmpty,
                    !email.isEmpty,
                    !username.isEmpty,
                    self.checkLength(of: password),
                    self.checkNumbersExistence(in: password),
                    self.checkEquality(of: password, and: passwordConfirmation)
                )
            }
            .subscribe(onNext: { [weak self] isFirstNameFilled, isLastNameFilled, isEmailFilled, isUsernameFilled, isLengthValid, hasNumbers, passwordAndConfirmationMatches in
                self?.passwordLengthLabel.textColor = isLengthValid ? .green : .red
                self?.passwordNumbersLabel.textColor = hasNumbers ? .green : .red
                self?.passwordMatchLabel.textColor = passwordAndConfirmationMatches ? .green : .red
                
                self?.registerButton.isEnabled = isFirstNameFilled && isLastNameFilled && isEmailFilled && isUsernameFilled && isLengthValid && hasNumbers && passwordAndConfirmationMatches
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .withLatestFrom(fields)
            .flatMapLatest({ [weak self] firstName, lastName, email, username, password, _ in
                return self?.userService.rx.register(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    username: username,
                    password: password)
                .asObservable()
                .observe(on: MainScheduler.instance)
                .catch({ [weak self] error in
                    guard let self = self else { return .empty() }
                    
                    self.showAlert(withMessage: "Something went wrong")
                    
                    return .empty()
                }) ?? .empty()
            })
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(withMessage: "User created!")
            })
            .disposed(by: disposeBag)
    }
    
    private func checkLength(of password: String) -> Bool {
        return minimumValidPasswordLength...maximumValidPasswordLength ~= password.count
    }
    
    private func checkNumbersExistence(in password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    private func checkEquality(of password: String, and passwordConfirmation: String) -> Bool {
        return !password.isEmpty && password == passwordConfirmation
    }
}
