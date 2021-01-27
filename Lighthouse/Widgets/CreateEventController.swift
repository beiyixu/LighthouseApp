//
//  CreateEventController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 1/26/21.
//

import UIKit
import Firebase

class CreateEventController: UIViewController {
    
    private var startDatePicker = UIDatePicker()
    private var endDatePicker = UIDatePicker()
    var finalStartDate = String(Date().timeIntervalSince1970)
    var finalEndDate = String(Date().timeIntervalSince1970)
    
    private let captionView: PlaceholderTextView = {
        let tv = PlaceholderTextView()
        tv.placeholderLabel.text = "Add a Caption..."
        tv.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.autocorrectionType = .no
        tv.borderWidth = 1
        tv.borderColor = UIColor(white: 0, alpha: 0.05)
        tv.clipsToBounds = true
        tv.cornerRadius = 5
        return tv
    }()
    
    private lazy var titleEvent: UITextField = {
        let t = UITextField()
        t.autocorrectionType = .no
        t.autocapitalizationType = .none
        t.placeholder = "Add a Title to Your Event"
        t.font = UIFont.systemFont(ofSize: 15)
        t.textColor = .black
        t.borderStyle = .roundedRect
        return t
    }()
    
    private let startLabel: UILabel = {
       let l = UILabel()
        l.text = "Event Start Date:"
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = .black
        return l
    }()
    
    private let endLabel: UILabel = {
       let l = UILabel()
        l.text = "Event End Date:"
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = .black
        return l
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 241, green: 241, blue: 241)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        layoutViews()
    }
    
    private func layoutViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 100)
        let containerView2 = UIView()
        containerView2.backgroundColor = .white
        view.addSubview(titleEvent)
        titleEvent.anchor(top: containerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 50)
        view.addSubview(containerView2)
        containerView2.anchor(top: titleEvent.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 100)
        containerView2.addSubview(captionView)
        captionView.anchor(top: containerView2.topAnchor, left: containerView2.leftAnchor, bottom: containerView2.bottomAnchor, right: containerView2.rightAnchor)
        let stackView = UIStackView(arrangedSubviews: [startLabel,startDatePicker])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        let stackView2 = UIStackView(arrangedSubviews: [endLabel,endDatePicker])
        stackView2.axis = .horizontal
        stackView2.alignment = .center
        stackView2.spacing = 20
        stackView2.distribution = .equalCentering
        let stackView3 = UIStackView(arrangedSubviews: [stackView,stackView2])
        stackView3.axis = .vertical
        stackView3.distribution = .fillEqually
        containerView.addSubview(stackView3)
        stackView3.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 15, paddingRight: 15)
    
        
    }
    
    @objc private func handleShare() {
        guard let caption = captionView.text else { return }
        guard let title = titleEvent.text else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        captionView.isUserInteractionEnabled = false
        titleEvent.isUserInteractionEnabled = false
        
        Database.database().createEvent(caption: caption, startDate: finalStartDate, endDate: finalEndDate, title: title) { (err) in
            if err != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.captionView.isUserInteractionEnabled = true
                self.titleEvent.isUserInteractionEnabled = true
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.updateHomeFeed, object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        titleEvent.resignFirstResponder()
        captionView.resignFirstResponder()
    }
    
    @objc private func dateChanged() {
        let startDate = String(Date().timeIntervalSince(startDatePicker.date))
        let endDate = String(Date().timeIntervalSince(endDatePicker.date))
        finalEndDate = endDate
        finalStartDate = startDate
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
