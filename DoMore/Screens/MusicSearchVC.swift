//
//  MusicSearchScreen.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit
import MusicKit

protocol MusicSearchVCDelegate: AnyObject {
    func didAddSong(song: Item)
    func didRemoveSong(song: Item)
}

class MusicSearchVC: UIViewController {
    
    let tableView = UITableView()
    var musicLibrary = [Item]()
    var duplicates = [String]()
    weak open var delegate: MusicSearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureTableView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Add songs"
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground.withAlphaComponent(0.50)
        searchController.searchBar.returnKeyType = .continue
        navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        tableView.rowHeight = 60
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchMusic(term: String) {
        self.showSpinner()
        Task {
            await NetworkManager.shared.fetchMusic(term: term) { [weak self] result in
                guard let self else { return }
                self.hideSpinner()
                switch result {
                case .success(let music):
                    if music.isEmpty {
                        DispatchQueue.main.async {
                            self.musicLibrary.removeAll()
                            self.tableView.reloadData()
                        }
                    } else {
                        self.musicLibrary = music
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
    }
    
    @objc 
    func closeButtonTapped() {
        dismiss(animated: true)
    }
}

//MARK: Table View Delegates
extension MusicSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicLibrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseID, for: indexPath) as! SearchCell
        let song = musicLibrary[indexPath.row]
        cell.isSongOnLibrary(duplicates: duplicates, song: song)
        cell.set(song: song)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)! as! SearchCell
        let song = musicLibrary[indexPath.row]
        
        if !currentCell.isOnLibrary {
            delegate?.didAddSong(song: song)
            duplicates.append(song.id)
            currentCell.addButton.setImage(UIImage(systemName: SFSymbols.minus), for: .normal)
            currentCell.isOnLibrary = true
        }
        else {
            delegate?.didRemoveSong(song: song)
            duplicates.removeAll { $0 == song.id }
            currentCell.addButton.setImage(UIImage(systemName: SFSymbols.plus), for: .normal)
            currentCell.isOnLibrary = false
        }
    }
}

//MARK: Search Bar
extension MusicSearchVC: UISearchResultsUpdating { 
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text, !search.isEmpty else {
            musicLibrary.removeAll()
            tableView.reloadData()
            showEmptyStateView(with: "Play the music you love", in: self.view)
            return }
        Task { fetchMusic(term: search) }
    }
}
