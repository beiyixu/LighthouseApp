//
//  HomePostCellHeader.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/25/20.
//

import UIKit

protocol HomePostCellHeaderDelegate {
    func didTapUser()
    func didTapOptions()
}

class HomePostCellHeader: UIView {
    
    // Declare Vars

    var user: User? {
        didSet {
            configureUser()
        }
    }
    
    var delegate: HomePostCellHeaderDelegate?
    
    private var padding: CGFloat = 8
    
    private let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user")
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 0.5
        iv.isUserInteractionEnabled  = true
        return iv
    }()
    
    private let usernameButton: UIButton = {
        let label = UIButton(type: .system)
        label.setTitleColor(.white, for: .normal)
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        label.contentHorizontalAlignment = .left
        label.addTarget(self, action: #selector(handleUserTap), for: .touchUpInside)
        return label
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleOptionsTap), for: .touchUpInside)
        return button
    }()
    
    private let verified: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "verified").withRenderingMode(.automatic).withTintColor(.systemYellow)
        i.contentMode = .scaleAspectFit
        i.isHidden = true
        return i
    }()
    
    // Main
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        self.layer.backgroundColor = UIColor.mainBlue.cgColor
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: padding, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUserTap)))
        
        addSubview(optionsButton)
        optionsButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: padding, width: 44)
        addSubview(verified)
        verified.anchor(top: topAnchor, bottom: bottomAnchor, right: optionsButton.leftAnchor, width: 20)
        
        addSubview(usernameButton)
        usernameButton.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: bottomAnchor, paddingLeft: 8)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.mainBlue.cgColor
    }
    
    private func configureUser() {
        guard let user = user else { return }
        usernameButton.setTitle(user.username, for: .normal)
        if let profileImageUrl = user.profileImageUrl {
            userProfileImageView.loadImage(urlString: profileImageUrl)
        } else {
            userProfileImageView.image = #imageLiteral(resourceName: "user")
        }
        if user.verified == true {
            verified.isHidden = false
        } else {
            verified.isHidden = true
        }
    }
    
    @objc private func handleUserTap() {
        delegate?.didTapUser()
    }
    
    @objc private func handleOptionsTap() {
        delegate?.didTapOptions()
    }
}
