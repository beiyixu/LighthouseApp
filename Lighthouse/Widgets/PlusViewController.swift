//
//  PlusViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 1/27/21.
//

import UIKit
import Firebase

class plusController: UIViewController {
    
    // Declare Vars

    private let postPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Photo", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(photoPressed), for: .touchUpInside)
        return button
    }()
    
    private let postCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Take Photo", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(takePressed), for: .touchUpInside)
        return button
    }()
    
    private let postTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Broadcast Message", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        return button
    }()
    
    private let postWidgetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Widget", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(widgetPressed), for: .touchUpInside)
        return button
    }()
    
    private let createEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create An Event", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(eventPressed), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        layoutViews()
       retrieveUser()
    }
    
    // Methods
    
    func setNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        navigationController?.navigationBar.barTintColor = .systemYellow
        let navLabel: UILabelGradient = {
            let label = UILabelGradient()
                label.text = "Create"
                label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 50)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.navigationItem.titleView = navLabel
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        NSLayoutConstraint.activate([
            navLabel.topAnchor.constraint(equalTo: containerView.topAnchor), navLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor), navLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10)
        ])
    }
    
    private func layoutViews() {
        let containerView = UIView()
        let stackView = UIStackView(arrangedSubviews: [postPhotoButton, postCameraButton, postTextButton, postWidgetButton, createEventButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(stackView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 500)
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
    }
    
    private func retrieveUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().fetchUser(withUID: uid) { (u) in
            if u.verified == true {
                self.createEventButton.isHidden = false
            }
        }
    }
    
    @objc private func photoPressed() {
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        let nacController = UINavigationController(rootViewController: photoSelectorController)
        nacController.modalPresentationStyle = .fullScreen
                present(nacController, animated: true, completion: nil)

    }
    
    @objc private func takePressed() {
        let camera = CameraController()
        let nacController = UINavigationController(rootViewController: camera)
        nacController.modalPresentationStyle = .fullScreen
        present(nacController, animated: true, completion: nil)
    }
  
    @objc private func sendPressed() {
        let send = SendViewController()
        let nacController = UINavigationController(rootViewController: send)
        nacController.modalPresentationStyle = .fullScreen
        present(nacController, animated: true, completion: nil)
    }
    
    @objc private func widgetPressed() {
        let create = CreateWidgetController()
        let nacController = UINavigationController(rootViewController: create)
        nacController.modalPresentationStyle = .fullScreen
        present(nacController, animated: true, completion: nil)
    }
    
    @objc private func eventPressed() {
        let send = CreateEventController()
        let nacController = UINavigationController(rootViewController: send)
        nacController.modalPresentationStyle = .fullScreen
        present(nacController, animated: true, completion: nil)
    }
  
    

}
