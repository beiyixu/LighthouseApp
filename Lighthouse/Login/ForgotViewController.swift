//
//  ForgotViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/19/20.
//

import UIKit
import Firebase

class ForgotViewController: UIViewController {

    private let forgotLabel: UILabel = {
        let l = UILabel()
        l.text = "Reset Your Password"
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textAlignment = .center
        l.textColor = .mainBlue
        l.cornerRadius = 5
        l.borderWidth = 0.5
        l.borderColor = .mainBlue
        l.backgroundColor = .systemYellow
        return l
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private let completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleForgot), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        setupInputFields()
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [forgotLabel, emailTextField, completionButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 200)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        emailTextField.resignFirstResponder()
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false
        if isFormValid {
            completionButton.isEnabled = true
            completionButton.backgroundColor = UIColor.mainBlue
        } else {
            completionButton.isEnabled = false
            completionButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc private func handleForgot() {
        guard let email = emailTextField.text else { return }
        emailTextField.isUserInteractionEnabled = false
        completionButton.isEnabled = false
        completionButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        ThemeService.showLoading(true)
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            ThemeService.showLoading(false)
            if error != nil {
                self.resetInputFields()
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func resetInputFields() {
        emailTextField.text = ""
        
        emailTextField.isUserInteractionEnabled = true
        
        completionButton.isEnabled = false
        completionButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ForgotViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

