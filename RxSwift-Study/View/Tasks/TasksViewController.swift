//
//  TasksViewController.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 04/01/23.
//

import UIKit
import RxSwift
import RxRelay

class TasksViewController: BaseViewController {
    // MARK: Private properties
    private var tasks = [Task]()
    private let viewModel: TasksViewModel
    private let disposeBag = DisposeBag()
    private let completeTask = PublishRelay<Task>()
    private let deleteTask = PublishRelay<Task>()
    private let reloadTasks = PublishRelay<Void>()
    
    // MARK: Initializer
    init(viewModel: TasksViewModel) {
        self.viewModel = viewModel
        super.init()
        title = "Tasks"
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: UI Components
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: String(describing: TaskTableViewCell.self))
        return tableView
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .add)
        barButtonItem.primaryAction = UIAction(handler: { [unowned self] _ in
            self.present(NewTaskVCFactory.make(), animated: true)
        })

        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buildView()
        
        setupBindings()
        
        reloadTasks.accept(Void())
    }

}

// MARK: View Code methods
extension TasksViewController: ViewCodeBuildable {
    func setupHierarchy() {
        view.addSubview(tasksTableView)
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func setupConstraints() {
        tasksTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tasksTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tasksTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tasksTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskTableViewCell.self), for: indexPath) as? TaskTableViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let task = tasks[indexPath.row]
        
        cell.configure(with: task)
        
        cell.deleteTaskTapped
            .bind(to: deleteTask)
            .disposed(by: cell.disposeBag)
        
        cell.completedChanged
            .bind(to: completeTask)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: Private API
extension TasksViewController {
    private func setupBindings() {
        let input = TasksViewModel.Input(completeTask: completeTask.asObservable(), deleteTask: deleteTask.asObservable(), reloadTasks: reloadTasks.asObservable())
        
        let output = viewModel.connect(input: input)
        
        output.tasks
            .drive(onNext: { [weak self] tasks in
                self?.tasks = tasks
                self?.tasksTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.taskCompleted
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    self?.reloadTasks.accept(Void())
                case .error(let error):
                    self?.showAlert(withMessage: error.localizedDescription, withTitle: "Error")
                }
            })
            .disposed(by: disposeBag)
        
        output.taskDeleted
            .drive(onNext: { task in
                self.showAlert(withMessage: "Task \(task.description) tapped to delete")
            })
            .disposed(by: disposeBag)
    }
}
