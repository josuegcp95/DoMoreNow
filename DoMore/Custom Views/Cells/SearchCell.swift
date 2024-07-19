//
//  SearchCell.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class SearchCell: UITableViewCell {
    
    static let reuseID = "SearchCell"
    let artwork = DMImageView(frame: .zero)
    let addButton = DMButton(systemImageName: SFSymbols.plus, backgroundColor: .systemBackground, foregroundColor: .systemGray)
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    var isOnLibrary = false
    
    lazy var songName: DMSubtitleLabel = {
        let songName = DMSubtitleLabel(fontSize: isIpad ? 21 : 17, textAlignment: .left)
        return songName
    }()
    
    lazy var artistName: DMBodyLabel = {
        let artistName = DMBodyLabel(fontSize: isIpad ? 19 : 15, textAlignment: .left)
        return artistName
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(song: Item) {
        artwork.downloadImage(fromURL: song.imageURL!.absoluteString)
        songName.text = song.name
        artistName.text = song.artist
    }
    
    func isSongOnLibrary(duplicates: [String], song: Item) {
        if duplicates.contains(song.id) {
            addButton.setImage(UIImage(systemName: SFSymbols.minus), for: .normal)
            isOnLibrary = true
        } else {
            addButton.setImage(UIImage(systemName: SFSymbols.plus), for: .normal)
            isOnLibrary = false
        }
    }
        
    private func configure() {
        addSubview(artwork)
        addSubview(songName)
        addSubview(artistName)
        addSubview(addButton)
                
        songName.adjustsFontSizeToFitWidth = true
        songName.minimumScaleFactor = 0.85
        artistName.adjustsFontSizeToFitWidth = true
        artistName.minimumScaleFactor = 0.85
        
        NSLayoutConstraint.activate([
            artwork.centerYAnchor.constraint(equalTo: centerYAnchor),
            artwork.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            artwork.widthAnchor.constraint(equalToConstant: isIpad ? 65 : 50),
            artwork.heightAnchor.constraint(equalToConstant: isIpad ? 65 : 50),
            
            songName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            songName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            songName.widthAnchor.constraint(equalToConstant: isIpad ? 450 : 250),
            songName.heightAnchor.constraint(equalToConstant: 20),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: isIpad ? 2.5 : 0),
            artistName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            artistName.widthAnchor.constraint(equalToConstant: isIpad ? 450 : 250),
            artistName.heightAnchor.constraint(equalToConstant: 20),
            
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: isIpad ? -24 : -16),
            addButton.widthAnchor.constraint(equalToConstant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
