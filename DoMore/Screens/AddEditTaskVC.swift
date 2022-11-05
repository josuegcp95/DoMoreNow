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
    
    let nameTextField = DMTextField()
    let timeTextField = DMTextField()
    var state: Bool?
    weak open var delegate: AddEditTaskVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNameTextField()
        configureDurationTextField()
        createDismissKeyboardTapGesture()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
//        title = "Add Task"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func configureNameTextField() {
        view.addSubview(nameTextField)
//        nameTextField.placeholder = "Enter name"
        nameTextField.returnKeyType = .continue
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureDurationTextField() {
        view.addSubview(timeTextField)
//        timeTextField.placeholder = "Enter time"
        timeTextField.keyboardType = .numberPad
        
        NSLayoutConstraint.activate([
            timeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            timeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func saveButtonTapped() {
        guard !nameTextField.text!.isEmpty, !timeTextField.text!.isEmpty else {
            self.presentDMAlertOnMainThread(title: "Something went wrong", message: DMError.bothFields.rawValue, buttonTitle: "OK")
            return }
        
        guard timeTextField.text!.isNumbersOnly else {
            self.presentDMAlertOnMainThread(title: "Something went wrong", message: DMError.onlyNumbers.rawValue, buttonTitle: "OK")
            return }
        
        if state! {
            let time = Int(timeTextField.text!)
            let newTask = Action(name: nameTextField.text!, time: time ?? 0, songs: [])
            delegate?.didAddNewTask(task: newTask)
            dismiss(animated: true)
        } else {
            let time = Int(timeTextField.text!)
            delegate?.didEditCurrentTask(name: nameTextField.text!, time: time ?? 0)
            dismiss(animated: true)
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

