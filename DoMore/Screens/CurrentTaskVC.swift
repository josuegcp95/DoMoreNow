//
//  CurrentTaskScreen.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit
import MusicKit

protocol CurrentTaskVCDelegate: AnyObject {
    func didUpdatePlaylist(music: [Item], indexPath: Int)
    func didEditCurrentTask(name: String, time: Int, indexPath: Int)
}

class CurrentTaskVC: UIViewController {
    
    let nameLabel = DMTitleLabel(fontSize: 35, textAlignment: .center)
    let timeLabel = DMBodyLabel(fontSize: 19, textAlignment: .center)
    let addSongButton = DMButton(title: "Add songs", backgroundColor: .systemPink)
    let startTaskButton = DMButton(title: "Start task", backgroundColor: .systemPink)
    let editTaskButton = DMButton(systemImageName: SFSymbols.pencil, backgroudColor: .systemBackground, foregroundColor: .systemGray)
    let tableView = UITableView()
    var playlist = [Item]()
    var tracks = [String]()
    var imagesDict = [String: String]()
    var position: Int?
    var minutes: Int?
    var musicSubscription: MusicSubscription?
    weak open var delegate: CurrentTaskVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureEditTaskButton()
        configureNameLabel()
        configureDurationLabel()
        configureAddSongButton()
        configureStartTaskButton()
        configureTableView()
        requestMusicKitAuth()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        isPlaylistEmpty()
        updateSubscriptionStatus()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Current Task"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureEditTaskButton() {
        view.addSubview(editTaskButton)
        editTaskButton.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            editTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            editTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editTaskButton.widthAnchor.constraint(equalToConstant: 20),
            editTaskButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.textColor = .systemPink
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: editTaskButton.bottomAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureDurationLabel() {
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -15),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            timeLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureAddSongButton() {
        view.addSubview(addSongButton)
        addSongButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        addSongButton.addTarget(self, action: #selector(addSongButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addSongButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 25),
            addSongButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            addSongButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            addSongButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureStartTaskButton() {
        view.addSubview(startTaskButton)
        startTaskButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        startTaskButton.addTarget(self, action: #selector(startTaskButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            startTaskButton.topAnchor.constraint(equalTo: addSongButton.bottomAnchor, constant: 15),
            startTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            startTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            startTaskButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.tag = 1
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: startTaskButton.bottomAnchor, constant: 35),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.heightAnchor.constraint(equalToConstant: 350),
        ])
    }
    
    @objc func editTaskButtonTapped() {
        let destVC = AddEditTaskVC()
        destVC.delegate = self
        destVC.state = false
        destVC.title = "Edit Task"
        destVC.nameTextField.placeholder = "New name"
        destVC.timeTextField.placeholder = "New time"
        destVC.nameTextField.text = nameLabel.text
        destVC.timeTextField.text = "\(minutes!)"
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.tintColor = .systemPink
        present(navController, animated: true)
    }
    
    @objc func addSongButtonTapped() {
        guard musicSubscription?.canPlayCatalogContent == true else {
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.unableToProceed.rawValue, buttonTitle: DMAlert.button)
            return }
        prepareTracks()
        let destVC = MusicSearchVC()
        destVC.delegate = self
        destVC.duplicates = tracks
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.tintColor = .systemPink
        present(navController, animated: true)
    }
    
    @objc func startTaskButtonTapped() {
        guard musicSubscription?.canPlayCatalogContent == true else {
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.unableToProceed.rawValue, buttonTitle: DMAlert.button)
            return }
        prepareTracks()
        prepareImages()
        let destVC = MusicPlayerVC()
        let seconds = minutes! * 60
        destVC.tracks = tracks
        destVC.imagesDict = imagesDict
        destVC.timerSeconds = seconds
        navigationController?.pushViewController(destVC, animated: true)
    }
  
    private func updateSubscriptionStatus() {
        Task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                musicSubscription = subscription
            }
        }
    }
    
    private func requestMusicKitAuth() {
        Task {
            await NetworkManager.shared.requestAuthorization { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    self.updateSubscriptionStatus()
                    return }
                self.updateSubscriptionStatus()
                self.presentDMAlertOnMainThread(title: DMAlert.title, message: error.rawValue, buttonTitle: DMAlert.button)
            }
        }
    }
        
    private func isPlaylistEmpty() {
        if playlist.isEmpty {
            startTaskButton.isEnabled = false
        } else {
            startTaskButton.isEnabled = true
        }
    }
    
    private func prepareTracks() {
        tracks.removeAll()
        for song in playlist {
            tracks.insert(song.id, at: 0)
        }
    }
    
    private func prepareImages() {
        imagesDict = [:]
        for song in playlist {
            imagesDict[song.name] = song.imageURL?.absoluteString
        }
    }
}

    //MARK: Table View Delegates
extension CurrentTaskVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.reuseID, for: indexPath) as! PlaylistCell
        let song = playlist[indexPath.row]
        cell.set(song: song)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        playlist.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        delegate?.didUpdatePlaylist(music: playlist, indexPath: position!)
        isPlaylistEmpty()
    }
}

    //MARK: Music Search View Controller Delegate
extension CurrentTaskVC: MusicSearchVCDelegate {
    func didAddSong(song: Item) {
        playlist.insert(song, at: 0)
        delegate?.didUpdatePlaylist(music: playlist, indexPath: position!)
        isPlaylistEmpty()
        tableView.reloadData()
    }
    
    func didRemoveSong(song: Item) {
        if let index = playlist.firstIndex(of: song) {
            playlist.remove(at: index)
        }
        delegate?.didUpdatePlaylist(music: playlist, indexPath: position!)
        isPlaylistEmpty()
        tableView.reloadData()
    }
}

    //MARK: Add/Edit Task View Controller Delegate
extension CurrentTaskVC: AddEditTaskVCDelegate {
    func didAddNewTask(task: Action) {
        //
    }
    
    func didEditCurrentTask(name: String, time: Int) {
        nameLabel.text = name
        timeLabel.text = "\(time) minutes"
        minutes = time
        delegate?.didEditCurrentTask(name: name, time: time, indexPath: position!)
    }
}
