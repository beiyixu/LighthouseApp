//
//  UserProfileHeader.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit
import Firebase

//MARK: - UserProfileHeaderDelegate

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
    func didChangeToWidgetView()
    func didPressEdit()
}

//MARK: - UserProfileHeader

class UserProfileHeader: UICollectionViewCell {
   
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            reloadData()
        }
    }
    
    private let userBackground: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.mainBlue
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "homeBackground")
        iv.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        iv.layer.borderWidth = 0.5
        return iv
        
    }()
    
    private let userRounded: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainBlue.cgColor
        return view
    }()
    
    private let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "user")
        iv.layer.borderColor = UIColor.mainBlue.cgColor
        iv.layer.borderWidth = 0.5
        return iv
    }()
    
    private let postsLabel = UserProfileStatsLabel(value: 0, title: "posts")
    private let followersLabel = UserProfileStatsLabel(value: 0, title: "followers")
    private let followingLabel = UserProfileStatsLabel(value: 0, title: "following")
    
    private lazy var followButton: UserProfileFollowButton = {
        let button = UserProfileFollowButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.mainBlue
        button.setImage(#imageLiteral(resourceName: "instagramlogo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleTapOnInstagram), for: .touchUpInside)
        return button
    }()
    
    private lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    private lazy var widgetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "widget"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleChangeToWidgetView), for: .touchUpInside)
        button.tintColor = UIColor.mainBlue
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()

    private let padding: CGFloat = 12
    
    static var headerId = "userProfileHeaderId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        
        addSubview(userBackground)
        userBackground.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 200)
        
        addSubview(userRounded)
        userRounded.anchor(top: userBackground.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -20)
        userRounded.backgroundColor = UIColor.white
    
        addSubview(profileImageView)
        profileImageView.anchor(top: userBackground.bottomAnchor, paddingTop: -80, width: 120, height: 120)
        profileImageView.centerXAnchor.constraint(equalTo: self.userBackground.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 120 / 2
        
        layoutBottomToolbar()
        
        layoutUserStatsView()
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 4, height: 20)
        nameLabel.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 0, height: 15)
        usernameLabel.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor).isActive = true
        
        addSubview(bioLabel)
        bioLabel.anchor(top: usernameLabel.bottomAnchor, bottom: followersLabel.topAnchor, paddingTop: 4)
        bioLabel.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor).isActive = true
           
    }
    
    private func layoutUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(left: leftAnchor, bottom: listButton.topAnchor, right: rightAnchor, paddingLeft: padding, paddingBottom: padding * 4, paddingRight: padding, height: 50)
    }
    
    private func layoutBottomToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.mainBlue
        
        let stackView = UIStackView(arrangedSubviews: [widgetButton, gridButton, listButton])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        stackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 44)
    }
    
    func reloadData() {
        guard let user = user else { return }
        usernameLabel.text = "@\(user.username)"
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        bioLabel.text = user.bio
        reloadFollowButton()
        reloadUserStats()
        if user.instagram != "" {
            addSubview(instagramButton)
            instagramButton.anchor(top: postsLabel.bottomAnchor, right: followingLabel.rightAnchor, paddingTop: 2, width: 40, height: 34)
            
            addSubview(followButton)
            followButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, right: instagramButton.leftAnchor, paddingTop: 2, paddingRight: 5, height: 34)
        } else {
            addSubview(followButton)
            followButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, right: followingLabel.rightAnchor, paddingTop: 2, height: 34)
        }
        if user.verified == true {
            let verified = UIImageView(image: #imageLiteral(resourceName: "verified").withTintColor(.mainBlue, renderingMode: .automatic))
            verified.contentMode = .scaleAspectFit
            addSubview(verified)
            verified.anchor(top: nameLabel.topAnchor, left: nameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, paddingLeft: 3)
            verified.widthAnchor.constraint(equalTo: verified.heightAnchor).isActive = true
        }
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    private func reloadFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            followButton.type = .edit
            return
        }
        
        let previousButtonType = followButton.type
        followButton.type = .loading
        
        Database.database().isFollowingUser(withUID: userId, completion: { (following) in
            if following {
                self.followButton.type = .unfollow
            } else {
                self.followButton.type = .follow
            }
        }) { (err) in
            self.followButton.type = previousButtonType
        }
    }
    
    private func reloadUserStats() {
        guard let uid = user?.uid else { return }
        
        Database.database().numberOfPostsForUser(withUID: uid) { (count) in
            self.postsLabel.setValue(count)
        }
        
        Database.database().numberOfFollowersForUser(withUID: uid) { (count) in
            self.followersLabel.setValue(count)
        }
        
        Database.database().numberOfFollowingForUser(withUID: uid) { (count) in
            self.followingLabel.setValue(count)
        }
    }
    
    @objc private func handleTap() {
        guard let userId = user?.uid else { return }
        if followButton.type == .edit {
            delegate?.didPressEdit()
        }
        
        let previousButtonType = followButton.type
        followButton.type = .loading
        
        if previousButtonType == .follow {
            Database.database().followUser(withUID: userId) { (err) in
                if err != nil {
                    self.followButton.type = previousButtonType
                    return
                }
                self.reloadFollowButton()
                self.reloadUserStats()
            }
            
        } else if previousButtonType == .unfollow {
            Database.database().unfollowUser(withUID: userId) { (err) in
                if err != nil {
                    self.followButton.type = previousButtonType
                    return
                }
                self.reloadFollowButton()
                self.reloadUserStats()
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.updateHomeFeed, object: nil)
    }
    
    @objc private func handleTapOnInstagram() {
        guard let user = user else { return }
        let screenName =  user.instagram
            let appURL = NSURL(string: "instagram://user?screen_name=\(screenName)")!
            let webURL = NSURL(string: "https://instagram.com/\(screenName)")!

            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            } else {
                //redirect to safari because the user doesn't have Instagram
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(webURL as URL)
                }
            }

        
    }
    
    @objc private func handleChangeToGridView() {
        gridButton.tintColor = UIColor.mainBlue
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        widgetButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    @objc private func handleChangeToListView() {
        listButton.tintColor = UIColor.mainBlue
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        widgetButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    @objc private func handleChangeToWidgetView() {
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        widgetButton.tintColor = UIColor.mainBlue
        delegate?.didChangeToWidgetView()
    }
}

//MARK: - UserProfileStatsLabel

private class UserProfileStatsLabel: UILabel {
    
    private var value: Int = 0
    private var title: String = ""
    
    init(value: Int, title: String) {
        super.init(frame: .zero)
        self.value = value
        self.title = title
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        numberOfLines = 0
        textAlignment = .center
        setAttributedText()
    }
    
    func setValue(_ value: Int) {
        self.value = value
        setAttributedText()
    }
    
    private func setAttributedText() {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        self.attributedText = attributedText
    }
}

//MARK: - FollowButtonType

private enum FollowButtonType {
    case loading, edit, follow, unfollow
}

//MARK: - UserProfileFollowButton

private class UserProfileFollowButton: UIButton {
    
    var type: FollowButtonType = .loading {
        didSet {
            configureButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        layer.borderColor = UIColor.mainBlue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
        configureButton()
    }
    
    private func configureButton() {
        switch type {
        case .loading:
            setupLoadingStyle()
        case .edit:
            setupEditStyle()
        case .follow:
            setupFollowStyle()
        case .unfollow:
            setupUnfollowStyle()
        }
    }
    
    private func setupLoadingStyle() {
        setTitle("Loading", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        isUserInteractionEnabled = false
    }
    
    private func setupEditStyle() {
        setTitle("Edit Profile", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        isUserInteractionEnabled = true
    }
    
    private func setupFollowStyle() {
        setTitle("Follow", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.mainBlue
        layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        isUserInteractionEnabled = true
    }
    
    private func setupUnfollowStyle() {
        setTitle("Unfollow", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        isUserInteractionEnabled = true
    }
}


