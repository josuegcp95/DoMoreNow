//
//  HomeScreen.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class HomeVC: UIViewController {
    
    private let tableView = UITableView()
    private let notificationCenter = UNUserNotificationCenter.current()
    private var localLibrary: [Action] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        requestLocalNotificationAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveTasks()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit,
                                        target: self,
                                        action: #selector(editButtonTapped))
        navigationItem.leftBarButtonItem = editButton
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func requestLocalNotificationAuth() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound,]) { [weak self] (granted, error) in
            guard let self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    self.presentDMAlertOnMainThread(title: DMAlert.title, message: "Error occurred requesting local notification authorization.", buttonTitle: DMAlert.button)
                }
            }
        }
    }
    
    @objc
    private func addButtonTapped() {
        let destVC = AddEditTaskVC()
        destVC.delegate = self
        destVC.isNewTask = true
        destVC.title = "Add Task"
        destVC.nameTextField.placeholder = "Task (name)"
        destVC.timeTextField.placeholder = "Time (minutes)"
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc
    private func editButtonTapped() {
        tableView.isEditing.toggle()
        configureViewController()
    }
    
    private func saveTasks(tasks: [Action]) {
        PersistenceManager.saveTasks(tasks: tasks) { [weak self] error in
            guard let self else { return }
            guard let error else { return }
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: error.rawValue, buttonTitle: DMAlert.button)
        }
    }
    
    private func retrieveTasks() {
        PersistenceManager.retrieveTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                if tasks.isEmpty {
                    self.showEmptyStateView(with: "You currently have no tasks...", in: self.view)
                } else {
                    self.localLibrary = tasks
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentDMAlertOnMainThread(title: DMAlert.title, message: error.rawValue, buttonTitle: DMAlert.button)
            }
        }
    }
        
    private func isLocalLibraryEmpty() {
        if localLibrary.isEmpty {
            self.showEmptyStateView(with: "You currently have no tasks...", in: self.view)
        } else {
            tableView.reloadData()
            view.bringSubviewToFront(self.tableView)
        }
    }
}

//MARK: Table View Methods
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localLibrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseID, for: indexPath) as! TaskCell
        let task = localLibrary[indexPath.row]
        cell.set(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destVC = CurrentTaskVC()
        destVC.delegate = self
        let task = localLibrary[indexPath.row]
        destVC.nameLabel.text = task.name
        destVC.timeLabel.text = "\(task.time) minutes"
        destVC.playlist = task.songs ?? []
        destVC.position = indexPath.row
        destVC.minutes = task.time
        navigationController?.pushViewController(destVC, animated: true)
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        localLibrary.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        saveTasks(tasks: localLibrary)
        isLocalLibraryEmpty()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        localLibrary.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        saveTasks(tasks: localLibrary)
    }

     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         return tableView.isEditing ? .none : .delete
     }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: Add/Edit Task View Controller Delegate
extension HomeVC: AddEditTaskVCDelegate {
    func didAddNewTask(task: Action) {
        localLibrary.insert(task, at: 0)
        saveTasks(tasks: localLibrary)
        isLocalLibraryEmpty()
    }
    
    func didEditCurrentTask(name: String, time: Int) {
        //
    }
}

//MARK: Current Task View Controller Delegate
extension HomeVC: CurrentTaskVCDelegate {
    func didUpdatePlaylist(music: [Item], indexPath: Int) {
        var musicUpdate = localLibrary[indexPath]
        musicUpdate.songs = music
        localLibrary[indexPath] = musicUpdate
        tableView.reloadData()
        saveTasks(tasks: localLibrary)
    }
    
    func didEditCurrentTask(name: String, time: Int, indexPath: Int) {
        var infoUpdate = localLibrary[indexPath]
        infoUpdate.name = name
        infoUpdate.time = time
        localLibrary[indexPath] = infoUpdate
        tableView.reloadData()
        saveTasks(tasks: localLibrary)
    }
}
