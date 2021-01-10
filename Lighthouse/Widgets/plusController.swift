//
//  plusController.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/16/20.
//

import UIKit

class plusController: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        layoutViews()
       
    }
    
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
        let stackView = UIStackView(arrangedSubviews: [postPhotoButton, postCameraButton, postTextButton, postWidgetButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(stackView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 400)
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
    }
    
    @objc private func photoPressed() {
        let layout = UICollectionViewFlowLayout()
                let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
                let nacController = UINavigationController(rootViewController: photoSelectorController)
                present(nacController, animated: true, completion: nil)

    }
    
    @objc private func takePressed() {
        let camera = CameraController()
        let nacController = UINavigationController(rootViewController: camera)
        present(nacController, animated: true, completion: nil)
    }
  
    @objc private func sendPressed() {
        let send = SendViewController()
        let nacController = UINavigationController(rootViewController: send)
        present(nacController, animated: true, completion: nil)
    }
    
    @objc private func widgetPressed() {
        let create = CreateWidgetController()
        let nacController = UINavigationController(rootViewController: create)
        present(nacController, animated: true, completion: nil)
    }
  
    

}
