//
//  LoginViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    private let logoContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let random = Int.random(in: 1...5)
        var background = UIImageView(image: #imageLiteral(resourceName: "background3"))
        if random == 1 {
            background.image = #imageLiteral(resourceName: "background2")
        } else if random == 2 {
            background.image = #imageLiteral(resourceName: "background1")
        } else if random == 3 {
            background.image = #imageLiteral(resourceName: "background5")
        } else if random == 4 {
            background.image = #imageLiteral(resourceName: "background")
        } else {
            background.image = #imageLiteral(resourceName: "background3")
        }
        background.borderWidth = 0.5
        background.contentMode = .scaleAspectFill
        container.addSubview(background)
        background.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor)
        
        return container
    }()
    
    private let logo: UIImageView = {
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "front-logo").withRenderingMode(.alwaysOriginal))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 50
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    private let label: UILabel = {
       let l = UILabel()
        l.textAlignment = .center
        let attext = NSMutableAttributedString(string: "Welcome to ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.mainBlue])
        attext.append(NSMutableAttributedString(string: "Lighthouse", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        l.attributedText = attext
        return l
    }()
    
    private let contentView: UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        v.cornerRadius = 15
        v.borderWidth = 0.5
        v.borderColor = .mainBlue
        return v
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.cornerRadius = 5
        tf.borderColor = .mainBlue
        tf.borderWidth = 0.5
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.cornerRadius = 5
        tf.borderColor = .mainBlue
        tf.borderWidth = 0.5
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.underlineStyle: 1])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainBlue, NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.underlineColor: UIColor.darkGray]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Forgot Password?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.mainBlue, NSAttributedString.Key.underlineStyle: 1])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowForgot), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    
        
        view.addSubview(logoContainerView)
        let height = view.bounds.height
        logoContainerView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: height)
        
        view.addSubview(logo)
        logo.anchor(top: logoContainerView.topAnchor, paddingTop: 50, width: 100, height: 100)
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.layer.cornerRadius = 50
        
        view.addSubview(contentView)
        contentView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20, height: 260)
        contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        setupInputFields()
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [label, emailTextField, passwordTextField, loginButton])
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        stackView.isOpaque = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 60, paddingRight: 20)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 25)
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: dontHaveAccountButton.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 25)
        
    }
    
    private func resetInputFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to sign in with email:", err)
                self.resetInputFields()
                return
            }
            if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                mainTabBarController.setupViewControllers()
                mainTabBarController.selectedIndex = 0
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc private func handleTapOnView() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.mainBlue
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc private func handleShowSignUp() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc private func handleShowForgot() {
        let nav = UINavigationController(rootViewController: ForgotViewController())
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
