//
//  PlaylistCell.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class PlaylistCell: UITableViewCell {

    static let reuseID = "PlaylistCell"
    let artwork = DMImageView(frame: .zero)
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
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
    
    private func configure() {
        addSubview(artwork)
        addSubview(songName)
        addSubview(artistName)
        
        backgroundColor = .secondarySystemBackground.withAlphaComponent(0.15)
        
        songName.adjustsFontSizeToFitWidth = true
        songName.minimumScaleFactor = 0.85
        artistName.adjustsFontSizeToFitWidth = true
        artistName.minimumScaleFactor = 0.85
        
        NSLayoutConstraint.activate([
            artwork.centerYAnchor.constraint(equalTo: centerYAnchor),
            artwork.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            artwork.widthAnchor.constraint(equalToConstant: isIpad ? 65 : 50),
            artwork.heightAnchor.constraint(equalToConstant: isIpad ? 65 : 50),
            
            songName.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            songName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            songName.widthAnchor.constraint(equalToConstant: isIpad ? 450 : 250),
            songName.heightAnchor.constraint(equalToConstant: 20),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: isIpad ? 2.5 : 0),
            artistName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            artistName.widthAnchor.constraint(equalToConstant: isIpad ? 450 : 250),
            artistName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

