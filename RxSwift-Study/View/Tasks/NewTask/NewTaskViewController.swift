//
//  NewTaskViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 20/01/23.
//

import UIKit

final class NewTaskViewController: BaseViewController {
    // MARK: Private properties
    private let viewModel: NewTaskViewModel
    private let horizontalMargin = 20.0
    
    // MARK: Initializer
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: UI Components
    private lazy var screenTitle: UILabel = {
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
    }
}

// MARK: View Code methods
extension NewTaskViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            screenTitle,
            descriptionTextField,
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
