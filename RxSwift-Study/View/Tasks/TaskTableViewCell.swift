//
//  TaskTableViewCell.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 05/01/23.
//

import UIKit
import RxSwift

class TaskTableViewCell: UITableViewCell {
    // MARK: Private properties
    private var task: Task? {
        didSet {
            if let task = task {
                self.completedSwitch.setOn(task.completed, animated: true)
                self.descriptionLabel.text = task.description
            }
        }
    }
    private(set) var disposeBag = DisposeBag()
    private let margin: CGFloat = 8.0
    
    // MARK: UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var completedSwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: Cell configuration
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        completedSwitch.isOn = false
    }

    public func configure(with task: Task) {
        self.task = task
    }
    
    // MARK: Cell actions
    public var deleteTaskTapped: Observable<Task> {
        guard let task = self.task else {
            fatalError("Task cell not configured")
        }
        
        return deleteButton.rx.tap
            .map { _ in
                return task
            }
            .asObservable()
    }
    
    public var completedChanged: Observable<Task> {
        guard var task = self.task else {
            fatalError("Task cell not configured")
        }

        return completedSwitch.rx.isOn
            .map { isOn in
                task.completed = isOn
                return task
            }
            .skip(1)
            .asObservable()
    }
}

extension TaskTableViewCell: ViewCodeBuildable {
    func setupHierarchy() {
        [
            completedSwitch,
            descriptionLabel,
            deleteButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
    }
    
    
}
