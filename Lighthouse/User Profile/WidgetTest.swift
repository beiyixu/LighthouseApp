//
//  WidgetTest.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/13/20.
//

import UIKit
import Charts
import Firebase

class WidgetTest: UIViewController, ChartViewDelegate {
    
    // Declare Vars

    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    override var canBecomeFirstResponder: Bool { return true }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var barChart2 = BarChartView()
    private lazy var barChart3 = BarChartView()
    
    private let actView = UIView()
    private let satView = UIView()
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let u = UISegmentedControl(items: ["SAT", "ACT"])
        u.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        u.selectedSegmentIndex = 0
        u.tintColor = .black
        u.backgroundColor = .systemYellow
        u.selectedSegmentTintColor = .mainBlue
        u.borderWidth = 0.5
        u.borderColor = .mainBlue
        u.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        return u
    }()
    
    private let gpaLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.backgroundColor = .systemYellow
        l.cornerRadius = 5
        l.borderWidth = 0.5
        l.borderColor = .mainBlue
        return l
    }()
    private let satLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.backgroundColor = .systemYellow
        l.cornerRadius = 5
        l.borderWidth = 0.5
        l.borderColor = .mainBlue
        return l
    }()
    private let actLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.backgroundColor = .systemYellow
        l.cornerRadius = 5
        l.borderWidth = 0.5
        l.borderColor = .mainBlue
        return l
    }()
    
    // Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Test Scores"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, height: 500)
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        let stackview = UIStackView(arrangedSubviews: [gpaLabel,satLabel,actLabel])
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.spacing = 12
        contentView.addSubview(stackview)
        stackview.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 100)
        
        contentView.addSubview(segmentedControl)
        segmentedControl.anchor(top: stackview.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 40)
        
        setUpBarChart()
        
        configureAlertController()
        
    }
    
    private func setUpBarChart() {
        contentView.addSubview(satView)
        satView.anchor(top: segmentedControl.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        satView.addSubview(barChart2)
        barChart2.anchor(top: satView.topAnchor, left: satView.leftAnchor, right: satView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        barChart2.heightAnchor.constraint(equalTo: self.barChart2.widthAnchor).isActive = true
        
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            actView.removeFromSuperview()
            contentView.addSubview(satView)
            satView.anchor(top: segmentedControl.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
            satView.addSubview(barChart2)
            barChart2.anchor(top: satView.topAnchor, left: satView.leftAnchor, right: satView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
            barChart2.heightAnchor.constraint(equalTo: self.barChart2.widthAnchor).isActive = true

        case 1:
            satView.removeFromSuperview()
            contentView.addSubview(actView)
            actView.anchor(top: segmentedControl.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
            actView.addSubview(barChart3)
            barChart3.anchor(top: actView.topAnchor, left: actView.leftAnchor, right: actView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
            barChart3.heightAnchor.constraint(equalTo: self.barChart3.widthAnchor).isActive = true
        default:
            break
        }
    }
    
    private func configureWidget() {
        guard let widget = widget else { return }
        if widget.user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        }
        
        setupChart()
    }
    
    private func setupChart() {
        guard let widget = self.widget else { return }
        var dataEntries = [BarChartDataEntry]()
        var dataEntries1 = [BarChartDataEntry]()
        let value = Int(widget.a) + widget.c
        let value2 = widget.b + widget.d
        let dataz = [Int(widget.a), widget.c, value]
        let dataz1 = [widget.b, widget.d, value2]
        for i in 0...2 {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataz[i]))
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: Double(dataz1[i]))
            dataEntries1.append(dataEntry1)
        }
        let dataSet = BarChartDataSet(entries: dataEntries, label: "25th Percentile")
        dataSet.colors = [UIColor.mainBlue]
        let dataSet2 = BarChartDataSet(entries: dataEntries1, label: "75th Percentile")
        dataSet2.colors = [UIColor.systemYellow]
        dataSet.valueColors = [.black]
        dataSet2.valueColors = [.black]
        let dataSet3: [BarChartDataSet] = [dataSet, dataSet2]
        let data = BarChartData(dataSets: dataSet3)
        data.barWidth = 0.35
        data.groupBars(fromX: 0, groupSpace: 0.3, barSpace: 0)
        barChart2.xAxis.axisMinimum = 0
        barChart2.xAxis.axisMaximum = 3
        barChart2.notifyDataSetChanged()
        barChart2.data = data
        
        barChart2.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Math", "Reading", "Composite"])
        barChart2.leftAxis.axisMinimum = 0
        barChart2.rightAxis.axisMinimum = 0
        barChart2.leftAxis.axisMaximum = 1800
        barChart2.rightAxis.axisMaximum = 1800
        barChart2.xAxis.centerAxisLabelsEnabled = true
        barChart2.xAxis.granularity = 1
        barChart2.xAxis.drawGridLinesEnabled = false
        barChart2.leftAxis.drawAxisLineEnabled = false
        barChart2.leftAxis.drawGridLinesEnabled = false
        barChart2.leftAxis.drawLabelsEnabled = false
        barChart2.rightAxis.drawAxisLineEnabled = false
        barChart2.rightAxis.drawLabelsEnabled = false
        barChart2.scaleYEnabled = false
        barChart2.scaleXEnabled = false
        barChart2.drawGridBackgroundEnabled = false
        barChart2.rightAxis.drawGridLinesEnabled = false
        barChart2.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let legend = barChart2.legend
        legend.orientation = .vertical
        legend.drawInside = true
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .top
        legend.xOffset = 30
        legend.yOffset = 30
        legend.yEntrySpace = 0
        barChart2.animate(yAxisDuration: 3)
        
        var dataEntries2 = [BarChartDataEntry]()
        var dataEntries3 = [BarChartDataEntry]()
        let value3 = (widget.e + widget.g + widget.i + widget.k) / 4
        let value4 = (widget.f + widget.h + widget.j + widget.l) / 4
        let dataz2 = [widget.e, widget.g, value3]
        let dataz3 = [widget.f, widget.h, value4]
        for i in 0...2 {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataz2[i]))
            dataEntries2.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: Double(dataz3[i]))
            dataEntries3.append(dataEntry1)
        }
        let dataSet4 = BarChartDataSet(entries: dataEntries2, label: "25th Percentile")
        dataSet4.colors = [UIColor.mainBlue]
        let dataSet5 = BarChartDataSet(entries: dataEntries3, label: "75th Percentile")
        dataSet5.colors = [UIColor.systemYellow]
        dataSet4.valueColors = [.black]
        dataSet5.valueColors = [.black]
        let dataSet6: [BarChartDataSet] = [dataSet4, dataSet5]
        let data1 = BarChartData(dataSets: dataSet6)
        data1.barWidth = 0.35
        data1.groupBars(fromX: 0, groupSpace: 0.3, barSpace: 0)
        barChart3.xAxis.axisMinimum = 0
        barChart3.xAxis.axisMaximum = 3
        barChart3.notifyDataSetChanged()
        barChart3.data = data1
        
        barChart3.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Math", "Reading", "Composite"])
        barChart3.leftAxis.axisMinimum = 0
        barChart3.rightAxis.axisMinimum = 0
        barChart3.leftAxis.axisMaximum = 40
        barChart3.rightAxis.axisMaximum = 40
        barChart3.xAxis.centerAxisLabelsEnabled = true
        barChart3.xAxis.granularity = 1
        barChart3.xAxis.drawGridLinesEnabled = false
        barChart3.leftAxis.drawAxisLineEnabled = false
        barChart3.leftAxis.drawGridLinesEnabled = false
        barChart3.leftAxis.drawLabelsEnabled = false
        barChart3.rightAxis.drawAxisLineEnabled = false
        barChart3.rightAxis.drawLabelsEnabled = false
        barChart3.scaleYEnabled = false
        barChart3.scaleXEnabled = false
        barChart3.drawGridBackgroundEnabled = false
        barChart3.rightAxis.drawGridLinesEnabled = false
        barChart3.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let legend2 = barChart3.legend
        legend2.orientation = .vertical
        legend2.drawInside = true
        legend2.horizontalAlignment = .left
        legend2.verticalAlignment = .top
        legend2.xOffset = 30
        legend2.yOffset = 30
        legend2.yEntrySpace = 0
        barChart3.animate(yAxisDuration: 3)
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "Average GPA", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSAttributedString(string: "\n\(widget.m)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        gpaLabel.attributedText = attributedText
        let attributedText1 = NSMutableAttributedString()
        attributedText1.append(NSAttributedString(string: "Average SAT", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        let v = (value + value2) / 2
        let v2 = (value3 + value4) / 2
        attributedText1.append(NSAttributedString(string: "\n\(v)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        satLabel.attributedText = attributedText1
        let attributedText2 = NSMutableAttributedString()
        attributedText2.append(NSAttributedString(string: "Average ACT", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText2.append(NSAttributedString(string: "\n\(v2)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        actLabel.attributedText = attributedText2
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("data").observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            let userACTR = userDictionary["actReading"] as? Int ?? 0
            let userACTE = userDictionary["actEnglish"] as? Int ?? 0
            let userACTM = userDictionary["actScience"] as? Int ?? 0
            let userACTS = userDictionary["actMath"] as? Int ?? 0
            let userSATM = userDictionary["satMath"] as? Int ?? 0
            let userSATR = userDictionary["satReading"] as? Int ?? 0
            var dataEntries10 = [BarChartDataEntry]()
            let value10 = userSATM + userSATR
            let dataz = [userSATM,userSATR, value10]
            for i in 0...2 {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataz[i]))
                dataEntries10.append(dataEntry)
            }
            let dataSetz = BarChartDataSet(entries: dataEntries10, label: "Your Score")
            dataSetz.colors = [UIColor.gray]
            let datab = BarChartData(dataSets: [dataSet,dataSetz,dataSet2])
            datab.barWidth = 0.25
            datab.groupBars(fromX: 0, groupSpace: 0.25, barSpace: 0)
            self.barChart2.data = datab
            self.barChart2.notifyDataSetChanged()
            var dataEntries11 = [BarChartDataEntry]()
            let value11 = (userACTR + userACTE + userACTM + userACTS) / 4
            let dataz1 = [userACTM, userACTR, value11]
            for i in 0...2 {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataz1[i]))
                dataEntries11.append(dataEntry)
            }
            let dataSetz2 = BarChartDataSet(entries: dataEntries11, label: "Your Score")
            dataSetz2.colors = [UIColor.gray]
            let datac = BarChartData(dataSets: [dataSet4,dataSetz2,dataSet5])
            datac.barWidth = 0.25
            datac.groupBars(fromX: 0, groupSpace: 0.25, barSpace: 0)
            self.barChart3.data = datac
            self.barChart3.notifyDataSetChanged()
        }
    }
    
    private func configureAlertController() {
        guard let widget = widget else { return }
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
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
        if currentLoggedInUserId == widget.user.uid {
        if let deleteWidgetAction = deleteAction(forPost: widget) {
            alertController.addAction(deleteWidgetAction)
        }
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
}
