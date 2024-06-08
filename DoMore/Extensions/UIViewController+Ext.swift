//
//  UIViewController+Ext.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit

fileprivate var loadingView: UIView!
fileprivate let activityIndicator = UIActivityIndicatorView(style: .large)

extension UIViewController {
    
    func presentDMAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = DMAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = DMEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func showSpinner() {
        loadingView = UIView(frame: view.bounds)
        view.addSubview(loadingView)
        loadingView.backgroundColor = .systemBackground
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.25) { loadingView.alpha = 0.75 }
        loadingView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            loadingView.isHidden = true
            loadingView.removeFromSuperview()
        }
    }
}
