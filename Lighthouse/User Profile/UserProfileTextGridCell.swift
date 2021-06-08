//
//  UserProfileTextGridCell.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/19/20.
//

import UIKit

protocol UserProfileTextGridCellDelegate {
    func didTapComment(post: Post)
    func didTapUser(user: User)
    func didTapOptions(post: Post)
    func didLike(for cell: UserProfileTextGridCell)
}

class UserProfileTextGridCell: UICollectionViewCell {
    
    // Declare Vars
    
    var delegate: UserProfileTextGridCellDelegate?
    
    var post: Post? {
        didSet {
            configurePost()
        }
    }
    
    let header = HomePostCellHeader()
    
    let background1 = UIView()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let padding: CGFloat = 12
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    private let likeCounter: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    static var cellId = "UserProfileTextGridCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            sharedInit()
    }
    
  
    private func sharedInit() {
        
        // cell rounded section
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.white.cgColor
        
        // cell shadow section
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.borderWidth = 10.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.mainBlue.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 20)
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
       let background = UIView()
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.mainBlue.cgColor
        background.layer.cornerRadius = 15
        background.isUserInteractionEnabled = false
        addSubview(captionLabel)
        captionLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        addSubview(background)
        background.anchor(top: topAnchor, left: leftAnchor, bottom: captionLabel.bottomAnchor, right: rightAnchor)
          
        setActionButtons()

        addSubview(likeCounter)
        likeCounter.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: padding, paddingLeft: padding)
      
    }
    
    // Methods
    
    private func setActionButtons() {
        addSubview(likeButton)
        likeButton.anchor(right: rightAnchor, paddingRight: padding)
        likeButton.centerYAnchor.constraint(equalTo: self.captionLabel.centerYAnchor).isActive = true
        
        addSubview(commentButton)
        commentButton.anchor(top: captionLabel.bottomAnchor, right: rightAnchor, paddingTop: padding, paddingRight: padding)
    }
    
    private func configurePost() {
        guard let post = post else { return }
        likeButton.setImage(post.likedByCurrentUser == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        setLikes(to: post.likes)
        setupAttributedCaption()
    }
    
    private func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "\n\(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: "\(timeAgoDisplay) \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        captionLabel.attributedText = attributedText
    }
    
    private func setLikes(to value: Int) {
        if value <= 0 {
            likeCounter.text = ""
        } else if value == 1 {
            likeCounter.text = "1 like"
        } else {
            likeCounter.text = "\(value) likes"
        }
    }
    
    @objc private func handleLike() {
        delegate?.didLike(for: self)
    }
    
    @objc private func handleComment() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
}

