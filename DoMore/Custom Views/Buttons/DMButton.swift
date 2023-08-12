//
//  DMButton.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class DMButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init (title: String, backgroundColor: UIColor) {
        self.init(frame: .zero)
        configuration?.title = title
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = .white
    }
    
    convenience init (systemImageName: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        self.init(frame: .zero)
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = foregroundColor
        configuration?.imagePlacement = .all
        configuration?.imagePadding = 5
        configuration?.cornerStyle = .capsule
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration = .filled()
        configuration?.cornerStyle = .medium
    }
}
