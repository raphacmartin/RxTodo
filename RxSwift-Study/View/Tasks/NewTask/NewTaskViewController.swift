//
//  NewTaskViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 20/01/23.
//

import RxRelay
import RxSwift
import UIKit

final class NewTaskViewController: BaseViewController {
    // MARK: Private properties
    private let viewModel: NewTaskViewModel
    private let horizontalMargin = 20.0
    private let dismissRelay = PublishRelay<Void>()
    
    // MARK: Public properties
    public var dismissed: Observable<Void> {
        dismissRelay.asObservable()
    }
    public let disposeBag = DisposeBag()
    
    // MARK: Initializer
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: UI Components
    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Create New Task"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Description"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var minCharLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Minimum 3 characters"
        label.font = UIFont.italicSystemFont(ofSize: 12.0)
        label.textColor = .darkGray
        
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Cancel", for: .normal)
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
}

// MARK: Lifecycle
extension NewTaskViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buildView()
        
        descriptionTextField.becomeFirstResponder()
        
        setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissRelay.accept(Void())
    }
}

// MARK: View Code methods
extension NewTaskViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            screenTitleLabel,
            descriptionTextField,
            minCharLabel,
            addButton,
            cancelButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
}

// MARK: Private API
extension NewTaskViewController {
    private func setupBindings() {
        let input = NewTaskViewModel.Input(
            description: descriptionTextField.rx.text.orEmpty.asObservable(),
            addTask: addButton.rx.tap.asObservable())
        
        let output = viewModel.connect(input: input)
        
        output.shouldEnableAddButton
            .asObservable()
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        cancelButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.taskAdded
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                switch response {
                case .success(_):
                    self?.dismiss(animated: true)
                case .error(let error):
                    self?.showAlert(withMessage: error.localizedDescription, withTitle: "Error")
                }
            })
            .disposed(by: disposeBag)
    }
}
