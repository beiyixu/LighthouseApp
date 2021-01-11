//
//  HomeTextCell.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/25/20.
//

import UIKit

protocol HomeTextCellDelegate {
    func didTapComment(post: Post)
    func didTapUser(user: User)
    func didTapOptions(post: Post)
    func didLike(for cell: HomeTextCell)
}

class HomeTextCell: UICollectionViewCell {
    
    var delegate: HomeTextCellDelegate?
    
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
    
    private let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.layer.cornerRadius = 15
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.image = #imageLiteral(resourceName: "like_unselected")
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let likeCounter: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    static var cellId = "homeTextCellId"
    
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
        self.contentView.layer.borderWidth = 20
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.rgb(red: 145, green: 165, blue: 255).cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 20)
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
       
        addSubview(header)
        header.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        header.delegate = self
            
        addSubview(captionLabel)
        captionLabel.anchor(top: header.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 15, paddingRight: 20)
        
        let captionBackground = UIView()
        addSubview(captionBackground)
        captionBackground.anchor(top: header.bottomAnchor, left: leftAnchor, bottom: captionLabel.bottomAnchor, right: rightAnchor)
        captionBackground.layer.cornerRadius = 15.0
        captionBackground.layer.borderWidth = 0.5
        captionBackground.layer.borderColor = UIColor.mainBlue.cgColor
        captionBackground.layer.masksToBounds = true
        captionBackground.layer.backgroundColor = UIColor.clear.cgColor
          
        setActionButtons()

        addSubview(likeCounter)
        likeCounter.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: padding, paddingLeft: padding)
      
    }
  
    
    private func setActionButtons() {
        addSubview(likeButton)
        likeButton.anchor(right: rightAnchor, paddingRight: padding - 6)
        likeButton.centerYAnchor.constraint(equalTo: self.captionLabel.centerYAnchor).isActive = true
        
        addSubview(commentButton)
        commentButton.anchor(top: captionLabel.bottomAnchor, right: rightAnchor, paddingTop: padding, paddingRight: padding)
    }
    
    private func configurePost() {
        guard let post = post else { return }
        header.user = post.user
        likeButton.setImage(post.likedByCurrentUser == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
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

//MARK: - HomePostCellHeaderDelegate

extension HomeTextCell: HomePostCellHeaderDelegate {
    
    func didTapUser() {
        guard let user = post?.user else { return }
        delegate?.didTapUser(user: user)
    }
    
    func didTapOptions() {
        guard let post = post else { return }
        delegate?.didTapOptions(post: post)
    }
}

