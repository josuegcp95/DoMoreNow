//
//  AddEditTaskVC.swift
//  DoMore
//
//  Created by Josue Cruz on 11/4/22.
//

import UIKit

protocol AddEditTaskVCDelegate: AnyObject {
    func didAddNewTask(task: Action)
    func didEditCurrentTask(name: String, time: Int)
}

class AddEditTaskVC: UIViewController {
    
    weak open var delegate: AddEditTaskVCDelegate?
    let nameTextField = DMTextField()
    let timeTextField = DMTextField()
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    var isNewTask: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNameTextField()
        configureDurationTextField()
        createDismissKeyboardTapGesture()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
          
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configureNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.returnKeyType = .continue
        nameTextField.addTarget(self, action: #selector(textFieldShouldReturn(sender:)), for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: isIpad ? 285 : 65),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: isIpad ? -285 : -65),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureDurationTextField() {
        view.addSubview(timeTextField)
        timeTextField.keyboardType = .numberPad
        
        NSLayoutConstraint.activate([
            timeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: isIpad ? 285 : 65),
            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: isIpad ? -285 : -65),
            timeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
        
    @objc
    private func saveButtonTapped() {
        guard !nameTextField.text!.isEmpty, !timeTextField.text!.isEmpty else {
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.allFields.rawValue, buttonTitle: DMAlert.button)
            return
        }
        
        guard timeTextField.text!.isNumbersOnly else {
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: DMError.onlyNumbers.rawValue, buttonTitle: DMAlert.button)
            return
        }
        
        guard let time = Int(timeTextField.text!), time > 0 else {
            self.presentDMAlertOnMainThread(title: DMAlert.title, message: "Time has to be greater than 0.", buttonTitle: DMAlert.button)
            return
        }
        
        if isNewTask! {
            let newTask = Action(name: nameTextField.text!, time: time, songs: [])
            delegate?.didAddNewTask(task: newTask)
            navigationController?.popViewController(animated: true)
        } else {
            delegate?.didEditCurrentTask(name: nameTextField.text!, time: time)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func textFieldShouldReturn(sender: UITextField) {
        nameTextField.resignFirstResponder()
        timeTextField.becomeFirstResponder()
    }
}

