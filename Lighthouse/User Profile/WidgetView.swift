//
//  WidgetView.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/20/20.
//

import UIKit
import Firebase

class WidgetView: UIViewController {
    
    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    
    private let background: UIView = {
       let b = UIView()
        b.layer.cornerRadius = 15.0
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.clear.cgColor
        b.layer.masksToBounds = true
        b.layer.backgroundColor = UIColor.black.cgColor
        return b
    }()
    
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
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Widget"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        
        view.addSubview(background)
        background.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        background.heightAnchor.constraint(equalTo: self.background.widthAnchor).isActive = true
        background.applyGradient(isVertical: false, x: view.bounds.width, y: view.bounds.width, colorArray: [.mainBlue,.mainBlue,.systemOrange,.systemYellow])
        
        createGradient()
        
        background.addSubview(questionLabel)
        questionLabel.anchor(top: background.topAnchor, left: background.leftAnchor, right: background.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        background.addSubview(answerLabel)
        answerLabel.anchor(top: questionLabel.bottomAnchor, left: background.leftAnchor, right: background.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        configureAlertController()
    }
    
    private func configureAlertController() {
        guard let widget = widget else { return }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let editWidgetAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            do {
                let Controller = WidgetEdit()
                Controller.widget = self.widget
                let navController = UINavigationController(rootViewController: Controller)
                self.present(navController, animated: true, completion: nil)
            }
        }
        alertController.addAction(editWidgetAction)
        
        if let deleteWidgetAction = deleteAction(forPost: widget) {
            alertController.addAction(deleteWidgetAction)
        }
        
    }
    
    private func deleteAction(forPost widget: Widget) -> UIAlertAction? {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return nil }
        
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            let alert = UIAlertController(title: "Delete Post?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                ThemeService.showLoading(true)
                Database.database().deleteWidget(withUID: currentLoggedInUserId, postId: widget.id) { (err) in
                    if err != nil {
                        return
                    }
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    mainTabBarController.selectedIndex = 4
                    ThemeService.showLoading(false)
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })
        return action
    }
    
    @objc private func handleSettings() {
        present(alertController, animated: true, completion: nil)
    }
    
    private func createGradient() {
        let gl = CAGradientLayer()
        gl.frame = self.background.bounds
        gl.colors = [UIColor.rgb(red: CGFloat.random(in: 1...75), green: CGFloat.random(in: 1...75), blue: CGFloat.random(in: 1...75)).cgColor, UIColor.rgb(red: CGFloat.random(in: 75...175), green: CGFloat.random(in: 75...175), blue: CGFloat.random(in: 75...175)).cgColor, UIColor.rgb(red: CGFloat.random(in: 175...255), green: CGFloat.random(in: 175...255), blue: CGFloat.random(in: 175...255)).cgColor]
        self.background.layer.addSublayer(gl)
    }
    
    private func configureWidget() {
        guard let widget = widget else { return }
        if widget.user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        }
        setupAttributedCaption()
    }
    
    private func setupAttributedCaption() {
        guard let widget = self.widget else { return }
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "\(widget.question)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        questionLabel.attributedText = attributedText
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.25
        
        let attributedText1 = NSMutableAttributedString()
        attributedText1.append(NSAttributedString(string: "\(widget.answer)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        answerLabel.attributedText = attributedText1
        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.minimumScaleFactor = 0.25
        
    }
    
}
