//
//  WidgetUserTest.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/14/20.
//

import UIKit
import Firebase

class WidgetUserTest: UIViewController {

    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    
    private let background: UIView = {
       let b = UIView()
        b.cornerRadius = 15.0
        b.borderWidth = 2
        b.layer.borderColor = UIColor.clear.cgColor
        b.layer.masksToBounds = true
        b.layer.backgroundColor = UIColor.black.cgColor
        return b
    }()
    
    private let background1: UIView = {
       let b = UIView()
        b.layer.cornerRadius = 15.0
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.clear.cgColor
        b.layer.masksToBounds = true
        b.layer.backgroundColor = UIColor.black.cgColor
        return b
    }()
    
    private let background2: UIView = {
       let b = UIView()
        b.layer.cornerRadius = 15.0
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.clear.cgColor
        b.layer.masksToBounds = true
        b.layer.backgroundColor = UIColor.black.cgColor
        return b
    }()
    
    private let gpaLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let satLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "My SAT"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    private let satMLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let satRLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let actLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "My ACT"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    private let actMLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let actRLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let actELabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let actSLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Widget"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, height: 1250)
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        contentView.addSubview(background)
        background.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        background.heightAnchor.constraint(equalTo: self.background.widthAnchor).isActive = true
        background.applyGradient(isVertical: false, x: view.bounds.width, y: view.bounds.width, colorArray: [.mainBlue,.mainBlue,.systemOrange,.systemYellow])
        
        contentView.addSubview(background1)
        background1.anchor(top: background.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        background1.heightAnchor.constraint(equalTo: self.background1.widthAnchor).isActive = true
        background1.applyGradient(isVertical: false, x: view.bounds.width, y: view.bounds.width, colorArray: [.systemYellow,.systemOrange,.mainBlue,.mainBlue])
        
        contentView.addSubview(background2)
        background2.anchor(top: background1.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        background2.heightAnchor.constraint(equalTo: self.background2.widthAnchor).isActive = true
        background2.applyGradient(isVertical: false, x: view.bounds.width, y: view.bounds.width, colorArray: [.mainBlue,.mainBlue,.systemOrange,.systemYellow])
        
        background.addSubview(gpaLabel)
        gpaLabel.anchor(top: background.topAnchor, left: background.leftAnchor, bottom: background.bottomAnchor, right: background.rightAnchor)
        
        background1.addSubview(satLabel)
        satLabel.anchor(top: background1.topAnchor, left: background1.leftAnchor, right: background1.rightAnchor, height: 50)
        let stackview = UIStackView(arrangedSubviews: [satMLabel,satRLabel])
        stackview.axis = .horizontal
        stackview.spacing = 12
        stackview.distribution = .equalSpacing
        
        background1.addSubview(stackview)
        stackview.anchor(top: satLabel.bottomAnchor, left: background1.leftAnchor, bottom: background1.bottomAnchor, right: background1.rightAnchor)
        
        background2.addSubview(actLabel)
        actLabel.anchor(top: background2.topAnchor, left: background2.leftAnchor, right: background2.rightAnchor, height: 50)
        
        let stackview1 = UIStackView(arrangedSubviews: [actMLabel,actRLabel])
        stackview1.axis = .horizontal
        stackview1.spacing = 12
        stackview1.distribution = .fillEqually
        
        let stackview2 = UIStackView(arrangedSubviews: [actELabel,actSLabel])
        stackview2.axis = .horizontal
        stackview2.spacing = 12
        stackview2.distribution = .fillEqually
        
        let stackview3 = UIStackView(arrangedSubviews: [stackview1,stackview2])
        stackview3.axis = .vertical
        stackview3.distribution = .fillEqually
        
        background2.addSubview(stackview3)
        stackview3.anchor(top: actLabel.bottomAnchor, left: background2.leftAnchor, bottom: background2.bottomAnchor, right: background2.rightAnchor)
        
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
        attributedText.append(NSAttributedString(string: "\("My GPA:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        attributedText.append(NSAttributedString(string: "\n\(widget.a)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        gpaLabel.attributedText = attributedText
        gpaLabel.adjustsFontSizeToFitWidth = true
        gpaLabel.minimumScaleFactor = 0.25
        
        let attributedText1 = NSMutableAttributedString()
        attributedText1.append(NSAttributedString(string: "\("SAT Math:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText1.append(NSAttributedString(string: "\n\(widget.f)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        satMLabel.attributedText = attributedText1
        satMLabel.adjustsFontSizeToFitWidth = true
        satMLabel.minimumScaleFactor = 0.25
        let attributedText2 = NSMutableAttributedString()
        attributedText2.append(NSAttributedString(string: "\("SAT Reading:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText2.append(NSAttributedString(string: "\n\(widget.g)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        satRLabel.attributedText = attributedText2
        satRLabel.adjustsFontSizeToFitWidth = true
        satRLabel.minimumScaleFactor = 0.25
        let attributedText3 = NSMutableAttributedString()
        attributedText3.append(NSAttributedString(string: "\("ACT Math:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText3.append(NSAttributedString(string: "\n\(widget.d)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        actMLabel.attributedText = attributedText3
        actMLabel.adjustsFontSizeToFitWidth = true
        actMLabel.minimumScaleFactor = 0.25
        let attributedText4 = NSMutableAttributedString()
        attributedText4.append(NSAttributedString(string: "\("ACT Reading:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText4.append(NSAttributedString(string: "\n\(widget.c)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        actRLabel.attributedText = attributedText4
        actRLabel.adjustsFontSizeToFitWidth = true
        actRLabel.minimumScaleFactor = 0.25
        let attributedText5 = NSMutableAttributedString()
        attributedText5.append(NSAttributedString(string: "\("ACT English:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText5.append(NSAttributedString(string: "\n\(widget.b)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        actELabel.attributedText = attributedText5
        actELabel.adjustsFontSizeToFitWidth = true
        actELabel.minimumScaleFactor = 0.25
        let attributedText6 = NSMutableAttributedString()
        attributedText6.append(NSAttributedString(string: "\("ACT Science:")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        attributedText6.append(NSAttributedString(string: "\n\(widget.e)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]))
        actSLabel.attributedText = attributedText6
        actSLabel.adjustsFontSizeToFitWidth = true
        actSLabel.minimumScaleFactor = 0.25
    }

}
