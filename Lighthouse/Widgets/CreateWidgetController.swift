//
//  CreateWidgetController.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/19/20.
//

import UIKit
import Firebase
import MapKit
import MobileCoreServices
import PDFKit


class CreateWidgetController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    var user: User? {
        didSet {
            configureUser()
        }
    }
    
    var content: String? {
        didSet {
            mapSetUp()
        }
    }
    
    var items = ["What is your favorite color?", "What is one of your hobbies?", "What sports do you play?", "What are your Grades?", "Upload Resume"]
    var selectedItem: String = "What is your favorite color?"
    
    private let reuploadButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .mainBlue
        b.cornerRadius = 5
        b.setTitle("Reupload", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(reuploadPdf), for: .touchUpInside)
        return b
    }()
    
    private let textView: PlaceholderTextView = {
        let tv = PlaceholderTextView()
        tv.placeholderLabel.text = "Answer the question..."
        tv.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textColor = .white
        label.backgroundColor = UIColor.mainBlue
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Select a Question to Answer"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Answer the Question"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let menLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemBlue
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Number of Male Students Enrolled"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let womanLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemPink
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Number of Female Students Enrolled"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let geographyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Number of Students From"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let ethnicityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Number of Students Of"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let acceptanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Acceptance Questions"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let satLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "SAT Scores"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let actLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "ACT Scores"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let gpaLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "Average GPA"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let gpaText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Average GPA"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numbersAndPunctuation
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let readingACT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 25th % Reading Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let readingACT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 75th % Reading Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let scienceACT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 25th % Science Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let scienceACT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 75th % Science Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let englishACT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 25th % English Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let englishACT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 75th % English Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    
    private let mathACT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 25th % Math Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let mathACT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT 75th % Math Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let readingSAT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT 25th % Reading Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let readingSAT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT 75th % Reading Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let mathSAT25Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT 25th % Math Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let mathSAT75Text: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT 75th % Math Score"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let menText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Male Students"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.borderColor = .gray
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let womanText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Female Students"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let midAtlanticText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Mid-Atlantic"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let newEnglandText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "New England"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let midWestText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Mid-West"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let southText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "South"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let westText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "West"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let internationalText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "International"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let whiteText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "White"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let blackText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Black"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let hispanicText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Hispanic"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let asianText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Asian"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let internationalEthnicityText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "International"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let otherText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Other"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let applicantsText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Applicants"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let acceptedText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Accepted"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let enrolledText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Enrolled"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let yourGPAText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "GPA"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numbersAndPunctuation
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourACTText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT MATH"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourACTText1: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT READING"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourACTText2: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT SCIENCE"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourACTText3: UITextField = {
        let tv = UITextField()
        tv.placeholder = "ACT ENGLISH"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourSATText: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT MATH"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    private let yourSATText1: UITextField = {
        let tv = UITextField()
        tv.placeholder = "SAT READING"
        tv.textAlignment = .center
        tv.borderWidth = 1
        tv.cornerRadius = 15
        tv.borderColor = .lightGray
        tv.keyboardType = .numberPad
        tv.font = UIFont.boldSystemFont(ofSize: 15)
        tv.autocorrectionType = .no
        return tv
    }()
    
    private let mapView: MKMapView = {
        let m = MKMapView()
        m.cornerRadius = 15
        m.borderWidth = 0.5
        m.borderColor = .mainBlue
        return m
    }()
    
    private let locationService = LocationService()
    
    private let pdfView = PDFView()
    
    private let picker = UIPickerView()
    
    let padding: CGFloat = 12
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        view.backgroundColor = .white
        
        retrieveUser()
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, height: 1250)
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.picker.delegate = self
        self.picker.dataSource = self
        contentView.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        
        contentView.addSubview(questionLabel)
        questionLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
        
        contentView.addSubview(picker)
        picker.anchor(top: questionLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 100)
        picker.borderWidth = 1
        picker.borderColor = .lightGray
        picker.cornerRadius = 15
        
        view.addSubview(answerLabel)
        answerLabel.anchor(top: picker.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
        
        view.addSubview(textView)
        textView.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 100)
        
        
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        textView.resignFirstResponder()
        menText.resignFirstResponder()
        womanText.resignFirstResponder()
        midAtlanticText.resignFirstResponder()
        midWestText.resignFirstResponder()
        westText.resignFirstResponder()
        newEnglandText.resignFirstResponder()
        internationalText.resignFirstResponder()
        southText.resignFirstResponder()
        blackText.resignFirstResponder()
        whiteText.resignFirstResponder()
        asianText.resignFirstResponder()
        hispanicText.resignFirstResponder()
        otherText.resignFirstResponder()
        internationalEthnicityText.resignFirstResponder()
        acceptedText.resignFirstResponder()
        enrolledText.resignFirstResponder()
        applicantsText.resignFirstResponder()
        readingACT25Text.resignFirstResponder()
        readingACT75Text.resignFirstResponder()
        mathACT25Text.resignFirstResponder()
        mathACT75Text.resignFirstResponder()
        scienceACT25Text.resignFirstResponder()
        scienceACT75Text.resignFirstResponder()
        englishACT25Text.resignFirstResponder()
        englishACT75Text.resignFirstResponder()
        readingSAT25Text.resignFirstResponder()
        readingSAT75Text.resignFirstResponder()
        mathSAT25Text.resignFirstResponder()
        mathSAT75Text.resignFirstResponder()
        gpaText.resignFirstResponder()
        yourSATText.resignFirstResponder()
        yourACTText.resignFirstResponder()
        yourGPAText.resignFirstResponder()
        yourSATText1.resignFirstResponder()
        yourACTText1.resignFirstResponder()
        yourACTText2.resignFirstResponder()
        yourACTText3.resignFirstResponder()
    }
    
    private func retrieveUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { (u) in
            self.user = u
        }
    }
    
    private func configureUser() {
        guard let user = user else { return }
        if user.verified == true {
            items.append("Demographics")
            items.append("Test Scores")
            items.append("Location")
            picker.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = items[row]
        if selectedItem == "Demographics" {
            mapView.removeFromSuperview()
            textView.removeFromSuperview()
            satLabel.removeFromSuperview()
            readingSAT25Text.removeFromSuperview()
            readingSAT75Text.removeFromSuperview()
            mathSAT25Text.removeFromSuperview()
            mathSAT75Text.removeFromSuperview()
            actLabel.removeFromSuperview()
            readingACT25Text.removeFromSuperview()
            readingACT75Text.removeFromSuperview()
            mathACT25Text.removeFromSuperview()
            mathACT75Text.removeFromSuperview()
            gpaText.removeFromSuperview()
            gpaLabel.removeFromSuperview()
            scienceACT25Text.removeFromSuperview()
            scienceACT75Text.removeFromSuperview()
            englishACT25Text.removeFromSuperview()
            englishACT75Text.removeFromSuperview()
            yourSATText1.removeFromSuperview()
            yourACTText1.removeFromSuperview()
            yourACTText2.removeFromSuperview()
            yourACTText3.removeFromSuperview()
            pdfView.removeFromSuperview()
            reuploadButton.removeFromSuperview()
            contentView.addSubview(menLabel)
            contentView.addSubview(womanLabel)
            contentView.addSubview(menText)
            contentView.addSubview(womanText)
            contentView.addSubview(geographyLabel)
            menLabel.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: self.contentView.centerXAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            womanLabel.anchor(top: answerLabel.bottomAnchor, left: self.contentView.centerXAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            menText.anchor(top: menLabel.bottomAnchor, left: contentView.leftAnchor, right: self.contentView.centerXAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            womanText.anchor(top: womanLabel.bottomAnchor, left: self.contentView.centerXAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            geographyLabel.anchor(top: womanText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            
            let stackview = UIStackView(arrangedSubviews: [midAtlanticText, newEnglandText, midWestText])
            let stackview2 = UIStackView(arrangedSubviews: [southText, westText, internationalText])
            stackview.axis = .horizontal
            stackview2.axis = .horizontal
            stackview.distribution = .fillEqually
            stackview2.distribution = .fillEqually
            stackview.spacing = padding
            stackview2.spacing = padding
            contentView.addSubview(stackview)
            stackview.anchor(top: geographyLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(stackview2)
            stackview2.anchor(top: stackview.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(ethnicityLabel)
            ethnicityLabel.anchor(top: southText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview3 = UIStackView(arrangedSubviews: [whiteText,blackText,hispanicText])
            let stackview4 = UIStackView(arrangedSubviews: [asianText,internationalEthnicityText,otherText])
            stackview3.axis = .horizontal
            stackview4.axis = .horizontal
            stackview3.distribution = .fillEqually
            stackview4.distribution = .fillEqually
            stackview3.spacing = padding
            stackview4.spacing = padding
            contentView.addSubview(stackview3)
            stackview3.anchor(top: ethnicityLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(stackview4)
            stackview4.anchor(top: stackview3.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(acceptanceLabel)
            acceptanceLabel.anchor(top: asianText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview5 = UIStackView(arrangedSubviews: [acceptedText,applicantsText,enrolledText])
            stackview5.axis = .horizontal
            stackview5.distribution = .fillEqually
            stackview5.spacing = padding
            contentView.addSubview(stackview5)
            stackview5.anchor(top: acceptanceLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            
        } else if selectedItem == "Test Scores" {
            mapView.removeFromSuperview()
            menLabel.removeFromSuperview()
            womanLabel.removeFromSuperview()
            womanText.removeFromSuperview()
            menText.removeFromSuperview()
            geographyLabel.removeFromSuperview()
            midAtlanticText.removeFromSuperview()
            newEnglandText.removeFromSuperview()
            midWestText.removeFromSuperview()
            southText.removeFromSuperview()
            westText.removeFromSuperview()
            internationalText.removeFromSuperview()
            whiteText.removeFromSuperview()
            blackText.removeFromSuperview()
            hispanicText.removeFromSuperview()
            asianText.removeFromSuperview()
            internationalEthnicityText.removeFromSuperview()
            otherText.removeFromSuperview()
            ethnicityLabel.removeFromSuperview()
            acceptanceLabel.removeFromSuperview()
            acceptedText.removeFromSuperview()
            applicantsText.removeFromSuperview()
            enrolledText.removeFromSuperview()
            textView.removeFromSuperview()
            yourSATText.removeFromSuperview()
            yourACTText.removeFromSuperview()
            yourGPAText.removeFromSuperview()
            pdfView.removeFromSuperview()
            reuploadButton.removeFromSuperview()
            
            contentView.addSubview(satLabel)
            satLabel.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview = UIStackView(arrangedSubviews: [mathSAT25Text,mathSAT75Text])
            stackview.axis = .horizontal
            stackview.distribution = .fillEqually
            stackview.spacing = padding
            contentView.addSubview(stackview)
            stackview.anchor(top: satLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview2 = UIStackView(arrangedSubviews: [readingSAT25Text,readingSAT75Text])
            stackview2.axis = .horizontal
            stackview2.distribution = .fillEqually
            stackview2.spacing = padding
            contentView.addSubview(stackview2)
            stackview2.anchor(top: stackview.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(actLabel)
            actLabel.anchor(top: stackview2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview3 = UIStackView(arrangedSubviews: [mathACT25Text,mathACT75Text])
            stackview3.axis = .horizontal
            stackview3.distribution = .fillEqually
            stackview3.spacing = padding
            contentView.addSubview(stackview3)
            stackview3.anchor(top: actLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview4 = UIStackView(arrangedSubviews: [readingACT25Text,readingACT75Text])
            stackview4.axis = .horizontal
            stackview4.distribution = .fillEqually
            stackview4.spacing = padding
            contentView.addSubview(stackview4)
            stackview4.anchor(top: stackview3.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview5 = UIStackView(arrangedSubviews: [scienceACT25Text,scienceACT75Text])
            stackview5.axis = .horizontal
            stackview5.distribution = .fillEqually
            stackview5.spacing = padding
            contentView.addSubview(stackview5)
            stackview5.anchor(top: stackview4.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            let stackview6 = UIStackView(arrangedSubviews: [englishACT25Text,englishACT75Text])
            stackview6.axis = .horizontal
            stackview6.distribution = .fillEqually
            stackview6.spacing = padding
            contentView.addSubview(stackview6)
            stackview6.anchor(top: stackview5.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(gpaLabel)
            gpaLabel.anchor(top: stackview6.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(gpaText)
            gpaText.anchor(top: gpaLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
        } else if selectedItem == "What are your Grades?" {
            mapView.removeFromSuperview()
            menLabel.removeFromSuperview()
            womanLabel.removeFromSuperview()
            womanText.removeFromSuperview()
            menText.removeFromSuperview()
            geographyLabel.removeFromSuperview()
            midAtlanticText.removeFromSuperview()
            newEnglandText.removeFromSuperview()
            midWestText.removeFromSuperview()
            southText.removeFromSuperview()
            westText.removeFromSuperview()
            internationalText.removeFromSuperview()
            whiteText.removeFromSuperview()
            blackText.removeFromSuperview()
            hispanicText.removeFromSuperview()
            asianText.removeFromSuperview()
            internationalEthnicityText.removeFromSuperview()
            otherText.removeFromSuperview()
            ethnicityLabel.removeFromSuperview()
            acceptanceLabel.removeFromSuperview()
            acceptedText.removeFromSuperview()
            applicantsText.removeFromSuperview()
            enrolledText.removeFromSuperview()
            satLabel.removeFromSuperview()
            readingSAT25Text.removeFromSuperview()
            readingSAT75Text.removeFromSuperview()
            mathSAT25Text.removeFromSuperview()
            mathSAT75Text.removeFromSuperview()
            actLabel.removeFromSuperview()
            readingACT25Text.removeFromSuperview()
            readingACT75Text.removeFromSuperview()
            mathACT25Text.removeFromSuperview()
            mathACT75Text.removeFromSuperview()
            scienceACT25Text.removeFromSuperview()
            scienceACT75Text.removeFromSuperview()
            englishACT25Text.removeFromSuperview()
            englishACT75Text.removeFromSuperview()
            gpaText.removeFromSuperview()
            gpaLabel.removeFromSuperview()
            textView.removeFromSuperview()
            pdfView.removeFromSuperview()
            reuploadButton.removeFromSuperview()
            contentView.addSubview(gpaLabel)
            gpaLabel.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourGPAText)
            yourGPAText.anchor(top: gpaLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(actLabel)
            actLabel.anchor(top: yourGPAText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourACTText)
            yourACTText.anchor(top: actLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourACTText1)
            yourACTText1.anchor(top: yourACTText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourACTText2)
            yourACTText2.anchor(top: yourACTText1.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourACTText3)
            yourACTText3.anchor(top: yourACTText2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(satLabel)
            satLabel.anchor(top: yourACTText3.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourSATText)
            yourSATText.anchor(top: satLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(yourSATText1)
            yourSATText1.anchor(top: yourSATText.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            
        } else if selectedItem == "Location" {
            menLabel.removeFromSuperview()
            womanLabel.removeFromSuperview()
            womanText.removeFromSuperview()
            menText.removeFromSuperview()
            geographyLabel.removeFromSuperview()
            midAtlanticText.removeFromSuperview()
            newEnglandText.removeFromSuperview()
            midWestText.removeFromSuperview()
            southText.removeFromSuperview()
            westText.removeFromSuperview()
            internationalText.removeFromSuperview()
            whiteText.removeFromSuperview()
            blackText.removeFromSuperview()
            hispanicText.removeFromSuperview()
            asianText.removeFromSuperview()
            internationalEthnicityText.removeFromSuperview()
            otherText.removeFromSuperview()
            ethnicityLabel.removeFromSuperview()
            acceptanceLabel.removeFromSuperview()
            acceptedText.removeFromSuperview()
            applicantsText.removeFromSuperview()
            enrolledText.removeFromSuperview()
            satLabel.removeFromSuperview()
            readingSAT25Text.removeFromSuperview()
            readingSAT75Text.removeFromSuperview()
            mathSAT25Text.removeFromSuperview()
            mathSAT75Text.removeFromSuperview()
            actLabel.removeFromSuperview()
            readingACT25Text.removeFromSuperview()
            readingACT75Text.removeFromSuperview()
            mathACT25Text.removeFromSuperview()
            mathACT75Text.removeFromSuperview()
            scienceACT25Text.removeFromSuperview()
            scienceACT75Text.removeFromSuperview()
            englishACT25Text.removeFromSuperview()
            englishACT75Text.removeFromSuperview()
            gpaText.removeFromSuperview()
            gpaLabel.removeFromSuperview()
            yourSATText.removeFromSuperview()
            yourACTText.removeFromSuperview()
            yourSATText1.removeFromSuperview()
            yourACTText1.removeFromSuperview()
            yourACTText2.removeFromSuperview()
            yourACTText3.removeFromSuperview()
            yourGPAText.removeFromSuperview()
            textView.removeFromSuperview()
            pdfView.removeFromSuperview()
            reuploadButton.removeFromSuperview()
            
            locationService.getLocation {[weak self] response in
              switch response {
              case .denied:
                self?.showAlert(title: "Error", message: "Please enable location services")
              case .location(let location):
                let message = ObjectMessage()
                message.content = location.string
                self?.content = message.content
              }
            }
            
            view.addSubview(mapView)
            mapView.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 500)
            
        } else if selectedItem == "Upload Resume" {
            textView.removeFromSuperview()
            mapView.removeFromSuperview()
            menLabel.removeFromSuperview()
            womanLabel.removeFromSuperview()
            womanText.removeFromSuperview()
            menText.removeFromSuperview()
            geographyLabel.removeFromSuperview()
            midAtlanticText.removeFromSuperview()
            newEnglandText.removeFromSuperview()
            midWestText.removeFromSuperview()
            southText.removeFromSuperview()
            westText.removeFromSuperview()
            internationalText.removeFromSuperview()
            whiteText.removeFromSuperview()
            blackText.removeFromSuperview()
            hispanicText.removeFromSuperview()
            asianText.removeFromSuperview()
            internationalEthnicityText.removeFromSuperview()
            otherText.removeFromSuperview()
            ethnicityLabel.removeFromSuperview()
            acceptanceLabel.removeFromSuperview()
            acceptedText.removeFromSuperview()
            applicantsText.removeFromSuperview()
            enrolledText.removeFromSuperview()
            satLabel.removeFromSuperview()
            readingSAT25Text.removeFromSuperview()
            readingSAT75Text.removeFromSuperview()
            mathSAT25Text.removeFromSuperview()
            mathSAT75Text.removeFromSuperview()
            actLabel.removeFromSuperview()
            readingACT25Text.removeFromSuperview()
            readingACT75Text.removeFromSuperview()
            mathACT25Text.removeFromSuperview()
            mathACT75Text.removeFromSuperview()
            scienceACT25Text.removeFromSuperview()
            scienceACT75Text.removeFromSuperview()
            englishACT25Text.removeFromSuperview()
            englishACT75Text.removeFromSuperview()
            gpaText.removeFromSuperview()
            gpaLabel.removeFromSuperview()
            yourSATText.removeFromSuperview()
            yourACTText.removeFromSuperview()
            yourSATText1.removeFromSuperview()
            yourACTText1.removeFromSuperview()
            yourACTText2.removeFromSuperview()
            yourACTText3.removeFromSuperview()
            yourGPAText.removeFromSuperview()
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
            documentPicker.delegate = self
            self.present(documentPicker, animated: true)
            contentView.addSubview(reuploadButton)
            reuploadButton.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 50)
            contentView.addSubview(pdfView)
            pdfView.anchor(top: reuploadButton.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 500)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            pdfView.autoScales = true
        } else {
            mapView.removeFromSuperview()
            menLabel.removeFromSuperview()
            womanLabel.removeFromSuperview()
            womanText.removeFromSuperview()
            menText.removeFromSuperview()
            geographyLabel.removeFromSuperview()
            midAtlanticText.removeFromSuperview()
            newEnglandText.removeFromSuperview()
            midWestText.removeFromSuperview()
            southText.removeFromSuperview()
            westText.removeFromSuperview()
            internationalText.removeFromSuperview()
            whiteText.removeFromSuperview()
            blackText.removeFromSuperview()
            hispanicText.removeFromSuperview()
            asianText.removeFromSuperview()
            internationalEthnicityText.removeFromSuperview()
            otherText.removeFromSuperview()
            ethnicityLabel.removeFromSuperview()
            acceptanceLabel.removeFromSuperview()
            acceptedText.removeFromSuperview()
            applicantsText.removeFromSuperview()
            enrolledText.removeFromSuperview()
            satLabel.removeFromSuperview()
            readingSAT25Text.removeFromSuperview()
            readingSAT75Text.removeFromSuperview()
            mathSAT25Text.removeFromSuperview()
            mathSAT75Text.removeFromSuperview()
            actLabel.removeFromSuperview()
            readingACT25Text.removeFromSuperview()
            readingACT75Text.removeFromSuperview()
            mathACT25Text.removeFromSuperview()
            mathACT75Text.removeFromSuperview()
            scienceACT25Text.removeFromSuperview()
            scienceACT75Text.removeFromSuperview()
            englishACT25Text.removeFromSuperview()
            englishACT75Text.removeFromSuperview()
            gpaText.removeFromSuperview()
            gpaLabel.removeFromSuperview()
            yourSATText.removeFromSuperview()
            yourACTText.removeFromSuperview()
            yourSATText1.removeFromSuperview()
            yourACTText1.removeFromSuperview()
            yourACTText2.removeFromSuperview()
            yourACTText3.removeFromSuperview()
            yourGPAText.removeFromSuperview()
            pdfView.removeFromSuperview()
            reuploadButton.removeFromSuperview()
            contentView.addSubview(textView)
            textView.anchor(top: answerLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: 100)
        }
        return
    }
    
    private func mapSetUp() {
        guard let location = content?.location else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    @objc private func reuploadPdf() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    @objc private func handleShare() {
        guard let answer = textView.text else { return }
        let question = selectedItem
        guard let male = menText.text else { return }
        guard let female = womanText.text else { return }
        guard let midAtlantic = midAtlanticText.text else { return }
        guard let newEngland = newEnglandText.text else { return }
        guard let midWest = midWestText.text else { return }
        guard let south = southText.text else { return }
        guard let west = westText.text else { return }
        guard let international = internationalText.text else { return }
        guard let white = whiteText.text else { return }
        guard let black = blackText.text else { return }
        guard let hispanic = hispanicText.text else { return }
        guard let asian = asianText.text else { return }
        guard let internationalEthnicity = internationalEthnicityText.text else { return }
        guard let other = otherText.text else { return }
        guard let accepted = acceptedText.text else { return }
        guard let enrolled = enrolledText.text else { return }
        guard let applicants = applicantsText.text else { return }
        guard let sat25math = mathSAT25Text.text else { return }
        guard let sat75math = mathSAT75Text.text else { return }
        guard let sat25reading = readingSAT25Text.text else { return }
        guard let sat75reading = readingSAT75Text.text else { return }
        guard let act25math = mathACT25Text.text else { return }
        guard let act75math = mathACT75Text.text else { return }
        guard let act25reading = readingACT25Text.text else { return }
        guard let act75reading = readingACT75Text.text else { return }
        guard let act25science = scienceACT25Text.text else { return }
        guard let act75science = scienceACT75Text.text else { return }
        guard let act25english = englishACT25Text.text else { return }
        guard let act75english = englishACT75Text.text else { return }
        guard let gpa = gpaText.text else { return }
        guard let yourGPA = yourGPAText.text else { return }
        guard let yourACTM = yourACTText.text else { return }
        guard let yourACTR = yourACTText1.text else { return }
        guard let yourACTS = yourACTText2.text else { return }
        guard let yourACTE = yourACTText3.text else { return }
        guard let yourSATM = yourSATText.text else { return }
        guard let yourSATR = yourSATText1.text else { return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        picker.isUserInteractionEnabled = false
        textView.isUserInteractionEnabled = false
        if question == "Demographics" {
            Database.database().createWidget2(male: male, female: female, midAtlantic: midAtlantic, newEngland: newEngland, midWest: midWest, south: south, west: west, international: international, white: white, black: black, hispanic: hispanic, asian: asian, internationalEthnicity: internationalEthnicity, other: other, accepted: accepted, applicants: applicants, enrolled: enrolled) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    return
            }
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else if question == "Test Scores" {
            Database.database().createWidget3(sat25math: sat25math, sat75math: sat75math, sat25reading: sat25reading, sat75reading: sat75reading, act25reading: act25reading, act75reading: act75reading, act25math: act25math, act75math: act75math,act25science: act25science,act75science: act75science,act25english: act25english,act75english: act75english, gpa: gpa) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else if question == "What are your Grades?" {
            Database.database().createWidget4(question: question, gpa: yourGPA, actR: yourACTR, actE: yourACTE, actM: yourACTM, actS: yourACTS, satM: yourSATM, satR: yourSATR) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    return
            }
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else if question == "Location" {
            
            guard let location = content?.location else { return }
            Database.database().createWidget5(question: question, location: location) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    return
            }
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else if question == "Upload Resume" {
            guard let pdfUrl = pdfView.document?.documentURL else { return }
            ThemeService.showLoading(true)
            Database.database().createWidget6(question: question, pdf: pdfUrl) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    ThemeService.showLoading(false)
                    return
            }
                ThemeService.showLoading(false)
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            Database.database().createWidget(question: question, answer: answer) { (err) in
                if err != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView.isUserInteractionEnabled = true
                    self.picker.isUserInteractionEnabled = true
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


}

extension CreateWidgetController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        pdfView.document = PDFDocument(url: url)
    }
}

extension CreateWidgetController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
