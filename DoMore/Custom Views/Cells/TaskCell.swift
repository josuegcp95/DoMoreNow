//
//  TaskCell.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

class TaskCell: UITableViewCell {
    
    static let reuseID = "TaskCell"
    let nameLabel = DMTitleLabel(fontSize: 29, textAlignment: .left)
    let timeLabel = DMBodyLabel(fontSize: 23, textAlignment: .left)
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(task: Action) {
        nameLabel.text = task.name
        timeLabel.text = "\(task.time) minutes"
    }
    
    private func configure() {
        addSubview(nameLabel)
        addSubview(timeLabel)
        
        nameLabel.textColor = .systemPink
        accessoryType = .disclosureIndicator
        
        if isIpad {
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
                nameLabel.widthAnchor.constraint(equalToConstant: 160),
                
                timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -72),
                timeLabel.widthAnchor.constraint(equalToConstant: 120)
            ])
        } else {
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
                nameLabel.widthAnchor.constraint(equalToConstant: 160),
                
                timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
                timeLabel.widthAnchor.constraint(equalToConstant: 120)
            ])
        }
    }
}
