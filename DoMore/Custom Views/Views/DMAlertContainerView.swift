//
//  DMAlertContainerView.swift
//  DoMore
//
//  Created by Josue Cruz on 10/25/22.
//

import UIKit

class DMAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemFill.cgColor
    }
}
