//
//  SignUp2ViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/15/20.
//

import UIKit
import Firebase

class SignUp2Controller: UIViewController {
    
    private lazy var firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var bioTextField: PlaceholderTextView = {
        let tf = PlaceholderTextView()
        tf.placeholderLabel.text = "Bio"
        tf.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.cornerRadius = 15
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderWidth = 1
        tf.borderColor = UIColor(white: 0, alpha: 0.03)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))

        setupInputFields()
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, bioTextField, signUpButton])
        firstNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bioTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingRight: 40, height: 200)
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func resetInputFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        bioTextField.text = ""
        
        firstNameTextField.isUserInteractionEnabled = true
        lastNameTextField.isUserInteractionEnabled = true
        bioTextField.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handleSignUp() {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let bio = bioTextField.text else { return }
        
        firstNameTextField.isUserInteractionEnabled = false
        lastNameTextField.isUserInteractionEnabled = false
        bioTextField.isUserInteractionEnabled = false
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        Auth.auth().updateUser(withUID: Auth.auth().currentUser!.uid, firstName: firstName, lastName: lastName, bio: bio) { (err) in
            if err != nil {
                return
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            mainTabBarController.selectedIndex = 0
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
    }
    
    
    @objc private func handleTextInputChange() {
        let isFormValid = firstNameTextField.text?.isEmpty == false && lastNameTextField.text?.isEmpty == false && bioTextField.text?.isEmpty == false
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.mainBlue
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    

    
}

extension SignUp2Controller: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
