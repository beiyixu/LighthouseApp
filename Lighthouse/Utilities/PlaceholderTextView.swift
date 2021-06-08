//
//  PlaceholderTextView.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    // Declare Vars
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // Methods
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    @objc private func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

class GradientView: UIView {
    
    let colors = UIColor.self
    
    let gl = CAGradientLayer()
    func gradient() {
        gl.type = .radial
        gl.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        gl.colors = [UIColor.rgb(red: CGFloat.random(in: 1...75), green: CGFloat.random(in: 1...75), blue: CGFloat.random(in: 1...75)).cgColor, UIColor.rgb(red: CGFloat.random(in: 75...175), green: CGFloat.random(in: 75...175), blue: CGFloat.random(in: 75...175)).cgColor, UIColor.rgb(red: CGFloat.random(in: 175...255), green: CGFloat.random(in: 175...255), blue: CGFloat.random(in: 175...255)).cgColor]
        self.layer.addSublayer(gl)
    }
}
