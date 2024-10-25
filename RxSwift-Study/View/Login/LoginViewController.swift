//
//  ViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    // MARK: Private properties
    let viewModel: LoginViewModel
    
    // MARK: Initializer
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
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
        
        #if DEBUG
        usernameTextField.text = "john.doe"
        passwordTextField.text = "123456789"
        usernameTextField.sendActions(for: .valueChanged)
        passwordTextField.sendActions(for: .valueChanged)
        #endif
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
        
        let input = LoginViewModel.Input(
            credentials: credentials,
            loginTapButtonEvent: loginButton.rx.tap.asObservable().mapTo(Void()))
        
        let output = viewModel.connect(input: input)
        
        output.shouldEnableLoginButton
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.login
            .drive(onNext: { [weak self] response in
                switch response {
                case .loggedIn(_):
                    // TODO: Remove static call from here
                    self?.navigationController?.setViewControllers([TasksVCFactory.make()], animated: true)
                case .unauthorized:
                    self?.showAlert(withMessage: "Wrong username or password")
                case .error(let error):
                    self?.showAlert(withMessage: "We're having problems to log you in")
                    print(error.localizedDescription)
                }
                
            })
            .disposed(by: disposeBag)
        
        output.showLoading
            .drive(isLoadingVisible)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.show(SignUpVCFactory.make(), sender: self)
            })
            .disposed(by: disposeBag)
    }
    
    private func isUnauthorized(_ error: Error) -> Bool {
        if let error = error as? APIError, case .httpError(let statusCode) = error, statusCode == 401 {
            return true
        }
        return false
    }
}
