//
//  CurrentTaskScreen.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit
import MusicKit
import SwiftUI

protocol CurrentTaskVCDelegate: AnyObject {
    func didUpdatePlaylist(music: [Item], indexPath: Int)
    func didEditCurrentTask(name: String, time: Int, indexPath: Int)
}

class CurrentTaskVC: UIViewController {
    
    weak open var delegate: CurrentTaskVCDelegate?
    private var musicSubscription: MusicSubscription?
    private let tableView = UITableView()
    private let addSongButton = DMButton(title: "Add songs", backgroundColor: .systemPink)
    private let startTaskButton = DMButton(title: "Start task", backgroundColor: .systemPink)
    private let editTaskButton = DMButton(systemImageName: SFSymbols.pencil, backgroundColor: .systemBackground, foregroundColor: .systemGray)
    let nameLabel = DMTitleLabel(fontSize: 35, textAlignment: .center)
    let timeLabel = DMBodyLabel(fontSize: 19, textAlignment: .center)
    var playlist = [Item]()
    private var tracks = [String]()
    private var imagesDict = [String: String]()
    var position: Int?
    var minutes: Int?
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    private var accessAllowed = false
    
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
        addSongButton.addTarget(self, action: #selector(addSongButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addSongButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 25),
            addSongButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isIpad ? 285 : 65),
            addSongButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isIpad ? -285 : -65),
            addSongButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureStartTaskButton() {
        view.addSubview(startTaskButton)
        startTaskButton.addTarget(self, action: #selector(startTaskButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            startTaskButton.topAnchor.constraint(equalTo: addSongButton.bottomAnchor, constant: 15),
            startTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isIpad ? 285 : 65),
            startTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isIpad ? -285 : -65),
            startTaskButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = isIpad ? 80 : 70
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.tag = 1
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: startTaskButton.bottomAnchor, constant: 35),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
        ])
    }
    
    @objc
    private func editTaskButtonTapped() {
        let destVC = AddEditTaskVC()
        destVC.delegate = self
        destVC.isNewTask = false
        destVC.title = "Edit Task"
        destVC.nameTextField.placeholder = "New name"
        destVC.timeTextField.placeholder = "New time"
        destVC.nameTextField.text = nameLabel.text
        destVC.timeTextField.text = "\(minutes!)"
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc
    private func addSongButtonTapped() {
        DispatchQueue.main.async { [self] in
            
            guard NetworkReachability.shared.isConnectedToInternet() else {
                presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.unavailableConnection.rawValue, buttonTitle: DMAlert.button)
                return
            }
            
            guard accessAllowed else { showAllowAccessAlert(); return }
            
            if (musicSubscription?.canPlayCatalogContent == false) {
                let offerView = MusicSubscriptionView()
                let offerVC = UIHostingController(rootView: offerView)
                present(offerVC, animated: true)
                return
            }
                
            prepareTracks()
            let destVC = MusicSearchVC()
            destVC.delegate = self
            destVC.duplicates = tracks
            
            if isIpad {
                navigationController?.pushViewController(destVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: destVC)
                navController.navigationBar.tintColor = .systemPink
                present(navController, animated: true)
            }
        }
    }
    
    @objc
    private func startTaskButtonTapped() {
        DispatchQueue.main.async { [self] in
            showSpinner()
            
            guard NetworkReachability.shared.isConnectedToInternet() else {
                hideSpinner()
                presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.unavailableConnection.rawValue, buttonTitle: DMAlert.button)
                return
            }
            
            guard accessAllowed else {
                hideSpinner()
                showAllowAccessAlert()
                return
            }
            
            if (musicSubscription?.canPlayCatalogContent == false) {
                self.hideSpinner()
                let offerView = MusicSubscriptionView()
                let offerVC = UIHostingController(rootView: offerView)
                present(offerVC, animated: true)
                return
            }
            
            prepareTracks()
            prepareImages()
            let destVC = MusicPlayerVC()
            let seconds = minutes! * 60
            tracks.shuffle()
            destVC.tracks = tracks
            destVC.imagesDict = imagesDict
            destVC.timerSeconds = seconds
            hideSpinner()
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    private func requestMusicKitAuth() {
        Task {
            await NetworkManager.shared.requestAuthorization { [weak self] error in
                guard let self else { return }
                guard let error else { self.updateSubscriptionStatus();
                    accessAllowed = true
                    return
                }
                self.updateSubscriptionStatus()
                
                switch error {
                case .accessDenied:
                    showAllowAccessAlert()
                default:
                    self.presentDMAlertOnMainThread(title: DMAlert.title, message: error.rawValue, buttonTitle: DMAlert.button)
                }
            }
        }
    }
    
    private func updateSubscriptionStatus() {
        Task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                musicSubscription = subscription
            }
        }
    }
    
    private func showAllowAccessAlert() {
        DispatchQueue.main.async { [self] in
            // Create alert
            let alert = UIAlertController(title: "Access Required", message: DMError.accessDenied.rawValue, preferredStyle: .alert)
            
            // Create actions
            let settingAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { _ in
                /// Go to settings
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(settingsURL) }
            }
            let cancelAction = UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel) { _ in
                /// Do nothing
            }
            // Add actions
            alert.addAction(settingAction)
            alert.addAction(cancelAction)
            
            // Present alert
            self.present(alert, animated: true)
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
            tracks.append(song.id)
        }
    }
    
    private func prepareImages() {
        imagesDict = [:]
        for song in playlist {
            imagesDict[song.name] = song.imageURL?.absoluteString
        }
    }
}

//MARK: Table View Methods
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
