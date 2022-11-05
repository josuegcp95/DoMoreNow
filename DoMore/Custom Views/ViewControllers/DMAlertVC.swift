//
//  DMAlertVC.swift
//  DoMore
//
//  Created by Josue Cruz on 10/25/22.
//

import UIKit

class DMAlertVC: UIViewController {
    
    let containerView = DMAlertContainerView()
    let titleLabel = DMTitleLabel(fontSize: 20, textAlignment: .center)
    let messageLabel = DMBodyLabel(fontSize: 15, textAlignment: .center)
    let actionButton = DMButton(title: "OK", backgroundColor: .systemRed)
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            containerView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            messageLabel.heightAnchor.constraint(equalToConstant: 54),
        ])
    }
    
   @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
