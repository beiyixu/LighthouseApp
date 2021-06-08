//
//  SendViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/17/20.
// 
//

import UIKit
import Firebase

class SendViewController: UIViewController {
    
    // Declare Variables
    
    private let textView: PlaceholderTextView = {
        let tv = PlaceholderTextView()
        tv.placeholderLabel.text = "Share Something..."
        tv.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.autocorrectionType = .no
        return tv
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 241, green: 241, blue: 241)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        layoutViews()
    }
    
    private func layoutViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 100)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
    }
    
    // Methods
    
    @objc private func handleShare() {
        guard let caption = textView.text else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        textView.isUserInteractionEnabled = false
        
        
        Database.database().createPostNoImage(caption: caption) { (err) in
            if err != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.textView.isUserInteractionEnabled = true
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.updateHomeFeed, object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
