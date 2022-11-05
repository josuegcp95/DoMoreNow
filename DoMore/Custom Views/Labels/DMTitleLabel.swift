//
//  DMTitleLabel.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class DMTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        lineBreakMode = .byTruncatingTail
    }
}
