//
//  UserProfileBackgroundCell.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/15/20.
//

import UIKit
import Firebase

class UserEdit: UIViewController, UINavigationControllerDelegate {
    
    // Declare Vars
    
    var user: User? {
        didSet {
            reloadData()
        }
    }
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Username:"
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name:"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name:"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Bio:"
        return label
    }()
    
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Instagram Username:"
        return label
    }()
    
    private let headerLabel: UILabelGradient = {
        let label = UILabelGradient()
        label.text = "Edit User"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .default
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.delegate = self
        return tf
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.delegate = self
        return tf
    }()
    
    private lazy var bioTextField: PlaceholderTextView = {
        let tf = PlaceholderTextView()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.cornerRadius = 5
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.borderColor = UIColor(white: 0, alpha: 0.1)
        tf.borderWidth = 0.7
        return tf
    }()
    
    private lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.4)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.isUserInteractionEnabled = false
        tf.delegate = self
        return tf
    }()
    
    private lazy var instagramTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Instagram"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.delegate = self
        return tf
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private let plusPhotoButton: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "user")
        iv.layer.borderColor = UIColor.mainBlue.cgColor
        iv.layer.borderWidth = 0.5
        iv.layer.cornerRadius = 50
        return iv
    }()
    
    private lazy var imageButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return b
    }()
    
    private var profileImage: UIImage?
    
    // Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        navigationController?.title = "Edit User"
        navigationItem.title = "Edit User"
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
    }
    
    private func layout() {
        let stackview1 = UIStackView(arrangedSubviews: [usernameLabel, usernameTextField])
        let stackview2 = UIStackView(arrangedSubviews: [firstNameLabel, firstNameTextField])
        let stackview3 = UIStackView(arrangedSubviews: [lastNameLabel, lastNameTextField])
        let stackview4 = UIStackView(arrangedSubviews: [bioLabel, bioTextField])
        let stackview6 = UIStackView(arrangedSubviews: [instagramLabel, instagramTextField])
        stackview1.axis = .horizontal
        stackview1.spacing = 10
        stackview1.distribution = .fillEqually
        stackview2.axis = .horizontal
        stackview2.spacing = 10
        stackview2.distribution = .fillEqually
        stackview3.axis = .horizontal
        stackview3.spacing = 10
        stackview3.distribution = .fillEqually
        stackview4.axis = .horizontal
        stackview4.spacing = 10
        stackview4.distribution = .fillEqually
        stackview6.axis = .horizontal
        stackview6.spacing = 10
        stackview6.distribution = .fillEqually
        let stackview5 = UIStackView(arrangedSubviews: [stackview1, stackview2, stackview3, stackview4, stackview6, saveButton])
        stackview5.distribution = .fillEqually
        stackview5.spacing = 10
        stackview5.axis = .vertical
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10, width: 100, height: 100)
        plusPhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.addSubview(imageButton)
        imageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10, width: 100, height: 100)
        imageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        view.addSubview(stackview5)
        stackview5.anchor(top: plusPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 350)
    }
    
    // Methods
    
    
    @objc private func handleSave() {
        guard let firstName = firstNameTextField.text else {return}
        guard let lastName = lastNameTextField.text else {return}
        guard let bio = bioTextField.text else {return}
        guard let instagram = instagramTextField.text else {return}
        
        firstNameTextField.isUserInteractionEnabled = false
        lastNameTextField.isUserInteractionEnabled = false
        bioTextField.isUserInteractionEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        Auth.auth().updateUser2(withUID: Auth.auth().currentUser!.uid, firstName: firstName, lastName: lastName, bio: bio, instagram: instagram, image: self.profileImage) { (err) in
            if err != nil {
                return
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            mainTabBarController.selectedIndex = 0
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        ThemeService.showLoading(true)
        navigationController?.present(imagePickerController, animated: true, completion: nil)
        ThemeService.showLoading(false)
    }
    
    func reloadData() {
        guard let user = user else { return }
        usernameTextField.text = "\(user.username)"
        firstNameTextField.text = "\(user.firstName)"
        lastNameTextField.text = "\(user.lastName)"
        bioTextField.text = "\(user.bio)"
        instagramTextField.text = "\(user.instagram)"
        if let profileImageUrl = user.profileImageUrl {
            plusPhotoButton.loadImage(urlString: profileImageUrl)
        }
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
        instagramTextField.resignFirstResponder()
    }
    
}

extension UserEdit: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserEdit: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.image = editedImage.withRenderingMode(.alwaysOriginal)
            profileImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.image = originalImage.withRenderingMode(.alwaysOriginal)
            profileImage = originalImage
        }
        plusPhotoButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        plusPhotoButton.layer.borderWidth = 0.5
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
