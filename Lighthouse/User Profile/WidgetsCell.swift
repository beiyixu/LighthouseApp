//
//  WidgetsCell.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/19/20.
//

import UIKit

protocol WidgetsCellDelegate {
    func didTapWidget(widget: Widget)
    func didTapChart(widget: Widget)
    func didTapTest(widget: Widget)
    func didTapUserTest(widget: Widget)
    func didTapLocation(widget: Widget)
    func didTapResume(widget: Widget)
}

class WidgetsCell: UICollectionViewCell {
    
    var delegate: WidgetsCellDelegate?
    
    var widget: Widget? {
        didSet {
            configurePost()
        }
    }
    
    let padding: CGFloat = 12
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 3
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var viewButton: UIButton = {
        let b = UIButton(type: .system)
        b.addTarget(self, action: #selector(handleTapOnView), for: .touchUpInside)
        return b
    }()
    
    static var cellId = "WidgetsGridCellId"
    
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
        createGradient()
        
        
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
       
        addSubview(questionLabel)
        questionLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        addSubview(answerLabel)
        answerLabel.anchor(top: questionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        setUpButton()
        
    }
    
    private func setUpButton() {
        
        addSubview(viewButton)
        viewButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    private func createGradient() {
        let gl = CAGradientLayer()
        gl.frame = self.contentView.bounds
        gl.colors = [UIColor.rgb(red: CGFloat.random(in: 1...75), green: CGFloat.random(in: 1...75), blue: CGFloat.random(in: 1...75)).cgColor, UIColor.rgb(red: CGFloat.random(in: 75...175), green: CGFloat.random(in: 75...175), blue: CGFloat.random(in: 75...175)).cgColor, UIColor.rgb(red: CGFloat.random(in: 175...255), green: CGFloat.random(in: 175...255), blue: CGFloat.random(in: 175...255)).cgColor]
        self.contentView.layer.addSublayer(gl)
    }
    
    private func configurePost() {
        guard widget != nil else { return }
        setupAttributedCaption()
    }
    
    private func setupAttributedCaption() {
        guard let widget = self.widget else { return }
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "\(widget.question)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        questionLabel.attributedText = attributedText
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
        
        let attributedText1 = NSMutableAttributedString()
        attributedText1.append(NSAttributedString(string: "\(widget.answer)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        answerLabel.attributedText = attributedText1
        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.minimumScaleFactor = 0.5
    }
    
    @objc private func handleTapOnView() {
        guard let widget = widget else { return }
        if widget.postType == 2 {
            delegate?.didTapChart(widget: widget)
        } else if widget.postType == 3 {
            delegate?.didTapTest(widget: widget)
        } else if widget.postType == 5 {
            delegate?.didTapUserTest(widget: widget)
        } else if widget.postType == 4 {
            delegate?.didTapLocation(widget: widget)
        } else if widget.postType == 6 {
            delegate?.didTapResume(widget: widget)
        } else {
            delegate?.didTapWidget(widget: widget)
        }
    }
    
}
