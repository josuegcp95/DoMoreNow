//
//  DMImageView.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class DMImageView: UIImageView {

    let placeholderImage = UIImage(systemName: SFSymbols.placeHolder)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit

        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    func downloadImage(fromURL url: String) {
//        image = MockData.images.randomElement()
        Task { image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage }
    }
}
