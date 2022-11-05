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
    let songName = DMSubtitleLabel(fontSize: 17, textAlignment: .left)
    let artistName = DMBodyLabel(fontSize: 15, textAlignment: .left)
    
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
            artwork.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            artwork.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            artwork.widthAnchor.constraint(equalToConstant: 50),
            artwork.heightAnchor.constraint(equalToConstant: 50),
            
            songName.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            songName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            songName.widthAnchor.constraint(equalToConstant: 250),
            songName.heightAnchor.constraint(equalToConstant: 20),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 0),
            artistName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            artistName.widthAnchor.constraint(equalToConstant: 250),
            artistName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

