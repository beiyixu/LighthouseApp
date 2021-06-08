//
//  PreviewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 1/31/21.
//

import UIKit

class PreviewController: UIViewController {
    
    // Declare Vars
    
    private let firstImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "front-logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Welcome To Lighthouse!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        attributedText.append(NSAttributedString(string: "\n\nLighthouse is an app dedicated to connecting you with college. With our core features, finding YOUR college is easier than ever. Tap NEXT To learn more!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let secondImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "firstPreview"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 50
        return imageView
    }()
    
    private let secondDescriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Lighthouse Has Awesome Features to Boost Your Networking!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        attributedText.append(NSAttributedString(string: "\n\nLighthouse has a core feed to view both your own experiences and also others you follow. It has In-App Messaging and Notifications so you can further explore offerings and truly communicate with a college counsler!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let thirdImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "secondPreview"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 50
        return imageView
    }()
    
    private let thirdDescriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Use Lighthouse's Widgets To Express Your Identity", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        attributedText.append(NSAttributedString(string: "\n\nLighthouse introduces revolutionary techniques for both colleges and applicants to express themselves. By uploading Grades and Documents like Resumes, applicants can compare themselves to other applicants and ultimately find their best college!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(subtractPage), for: .touchUpInside)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.cornerRadius = 10
        button.backgroundColor = .systemYellow
        button.borderWidth = 1
        button.borderColor = .mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(dismissPreview), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(addPage), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = .mainBlue
        pc.pageIndicatorTintColor = .systemYellow
        if #available(iOS 14.0, *) {
            pc.backgroundStyle = .prominent
        }
        pc.addTarget(self, action: #selector(pageChanged), for: .allEvents)
        return pc
    }()
    
    // Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(firstImageView)
        firstImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 50, paddingRight: 50)
        firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor).isActive = true
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        bottomControlsStackView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, height: 50)
        
        firstImageView.cornerRadius = (view.bounds.width - 100) / 2
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: firstImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 80, paddingRight: 30)

        view.addSubview(skipButton)
        skipButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 40, paddingRight: 20, width: 90, height: 40)
        
    }
    
    // Methods
    
    @objc private func pageChanged() {
        if pageControl.currentPage == 0 {
            secondImageView.removeFromSuperview()
            secondDescriptionTextView.removeFromSuperview()
            thirdDescriptionTextView.removeFromSuperview()
            thirdImageView.removeFromSuperview()
            view.addSubview(firstImageView)
            firstImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 50, paddingRight: 50)
            firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor).isActive = true
            
            view.addSubview(descriptionTextView)
            descriptionTextView.anchor(top: firstImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 80, paddingRight: 30)
        } else if pageControl.currentPage == 1 {
            firstImageView.removeFromSuperview()
            descriptionTextView.removeFromSuperview()
            thirdDescriptionTextView.removeFromSuperview()
            thirdImageView.removeFromSuperview()
            skipButton.removeFromSuperview()
            view.addSubview(secondImageView)
            secondImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 30)
            secondImageView.heightAnchor.constraint(equalTo: secondImageView.widthAnchor).isActive = true
            
            view.addSubview(secondDescriptionTextView)
            secondDescriptionTextView.anchor(top: secondImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 80, paddingRight: 30)
            view.addSubview(skipButton)
            skipButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 40, paddingRight: 20, width: 90, height: 40)
        } else {
            firstImageView.removeFromSuperview()
            descriptionTextView.removeFromSuperview()
            secondImageView.removeFromSuperview()
            secondDescriptionTextView.removeFromSuperview()
            skipButton.removeFromSuperview()
            view.addSubview(thirdImageView)
            thirdImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 30)
            thirdImageView.heightAnchor.constraint(equalTo: thirdImageView.widthAnchor).isActive = true
            
            view.addSubview(thirdDescriptionTextView)
            thirdDescriptionTextView.anchor(top: thirdImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 80, paddingRight: 30)
            view.addSubview(skipButton)
            skipButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 40, paddingRight: 20, width: 90, height: 40)
        }
    }
    
    @objc private func addPage() {
        if pageControl.currentPage < 2 {
            pageControl.currentPage = pageControl.currentPage + 1
            previousButton.setTitleColor(.gray, for: .normal)
            pageChanged()
            if pageControl.currentPage == 2 {
                nextButton.setTitle("EXIT", for: .normal)
            }
        } else if pageControl.currentPage == 2 {
            dismissPreview()
        }
    }
    
    @objc private func subtractPage() {
        if pageControl.currentPage > 0 {
            pageControl.currentPage = pageControl.currentPage - 1
            pageChanged()
            if pageControl.currentPage == 0 {
                previousButton.setTitleColor(.clear, for: .normal)
            }
            if pageControl.currentPage != 2 {
                nextButton.setTitle("NEXT", for: .normal)
            }
        }
    }
    
    @objc private func dismissPreview() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.setupViewControllers()
        mainTabBarController.selectedIndex = 0
        self.dismiss(animated: true, completion: nil)
    }

}
