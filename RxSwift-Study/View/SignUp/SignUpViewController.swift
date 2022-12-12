//
//  SignUpViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/27/22.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    // MARK: Private properties
    let viewModel: SignUpViewModel
    
    // MARK: Initializer
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
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
        let passwordLengthLabel = self.passwordLengthLabel
        passwordLengthLabel.text = "Password must contain \(viewModel.minimumValidPasswordLength) to \(viewModel.maximumValidPasswordLength) characters"
        
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
        let output = viewModel.connect(input: SignUpViewModel.Input(
            firstName: firstNameTextField.rx.text.orEmpty.asObservable(),
            lastName: lastNameTextField.rx.text.orEmpty.asObservable(),
            email: emailTextField.rx.text.orEmpty.asObservable(),
            username: usernameTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
            registerTapButtonEvent: registerButton.rx.tap.asObservable()))
        
        output.isPasswordLengthValid
            .map(self.getValidationColor)
            .drive(passwordLengthLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.passwordHaveNumbers
            .map(self.getValidationColor)
            .drive(passwordNumbersLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.passwordsMatch
            .map(self.getValidationColor)
            .drive(passwordMatchLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.shouldEnableRegisterButton
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showLoading
            .drive(isLoadingVisible)
            .disposed(by: disposeBag)
        
        output.register
            .drive(onNext: { response in
                switch response {
                case .signedUp:
                    self.showAlert(withMessage: "User created!")
                case .error(_):
                    self.showAlert(withMessage: "Something went wrong")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func getValidationColor(from isValid: Bool) -> UIColor {
        return isValid ? .green : .red
    }
}
