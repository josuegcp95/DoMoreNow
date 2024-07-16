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
    let songName = DMSubtitleLabel(fontSize: 17, textAlignment: .left)
    let artistName = DMBodyLabel(fontSize: 15, textAlignment: .left)
    let addButton = DMButton(systemImageName: SFSymbols.plus, backgroundColor: .systemBackground, foregroundColor: .systemGray)
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    var isOnLibrary = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(song: Item) {
//        let imageIcon = MockData.images.randomElement()
//        artwork.image = imageIcon
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
            artwork.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            artwork.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            artwork.widthAnchor.constraint(equalToConstant: 50),
            artwork.heightAnchor.constraint(equalToConstant: 50),
            
            songName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            songName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            songName.widthAnchor.constraint(equalToConstant: 250),
            songName.heightAnchor.constraint(equalToConstant: 20),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 0),
            artistName.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
            artistName.widthAnchor.constraint(equalToConstant: 250),
            artistName.heightAnchor.constraint(equalToConstant: 20),
            
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: isIpad ? -152 : -18),
            addButton.widthAnchor.constraint(equalToConstant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
