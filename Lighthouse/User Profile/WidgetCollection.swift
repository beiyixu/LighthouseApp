//
//  WidgetCollection.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/20/20.
//

import UIKit
import Charts
import Firebase

class WidgetChartView: UIViewController, ChartViewDelegate {
    
    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    private let questionLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var pieChart = PieChartView()
    private lazy var pieChart2 = PieChartView()
    private var entries = [ChartDataEntry]()
    private var entries2 = [ChartDataEntry]()
    private lazy var pieChart3 = PieChartView()
    private var entries3 = [ChartDataEntry]()
    private lazy var barChart = BarChartView()
    private var entries4 = [ChartDataEntry]()
    private lazy var barChart2 = BarChartView()
    private lazy var barChart3 = BarChartView()
    
    private let mfLabel: UILabel = {
       let l = UILabel()
        l.text = "Number of Male and Female Students"
        l.font = UIFont.boldSystemFont(ofSize: 10)
        l.textAlignment = .left
        l.textColor = .black
        return l
    }()
    private let placeLabel: UILabel = {
       let l = UILabel()
        l.text = "Students From"
        l.font = UIFont.boldSystemFont(ofSize: 10)
        l.textAlignment = .left
        l.textColor = .black
        return l
    }()
    private let ethniciityLabel: UILabel = {
       let l = UILabel()
        l.text = "Students Of"
        l.font = UIFont.boldSystemFont(ofSize: 10)
        l.textAlignment = .left
        l.textColor = .black
        return l
    }()
    private let acceptedLabel: UILabel = {
       let l = UILabel()
        l.text = "Acceptance"
        l.font = UIFont.boldSystemFont(ofSize: 10)
        l.textAlignment = .left
        l.textColor = .black
        return l
    }()
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demographics"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, height: 2000)
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        pieChart.delegate = self
        pieChart2.delegate = self
        pieChart3.delegate = self
        barChart.delegate = self
        barChart2.delegate = self
        setupPieChart()
        
        configureAlertController()
    }
    
    private func setupPieChart() {
        contentView.addSubview(pieChart)
        
        pieChart.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        pieChart.heightAnchor.constraint(equalTo: self.pieChart.widthAnchor).isActive = true
        
        contentView.addSubview(mfLabel)
        mfLabel.anchor(top: pieChart.topAnchor, left: contentView.leftAnchor, paddingLeft: 10)
        
        contentView.addSubview(pieChart2)
        
        pieChart2.anchor(top: pieChart.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingRight: 10)
        pieChart2.heightAnchor.constraint(equalTo: self.pieChart2.widthAnchor).isActive = true
        
        contentView.addSubview(placeLabel)
        placeLabel.anchor(top: pieChart2.topAnchor, left: contentView.leftAnchor, paddingLeft: 10)
        
        contentView.addSubview(pieChart3)
        
        pieChart3.anchor(top: pieChart2.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingRight: 10)
        pieChart3.heightAnchor.constraint(equalTo: self.pieChart3.widthAnchor).isActive = true
        
        contentView.addSubview(ethniciityLabel)
        ethniciityLabel.anchor(top: pieChart3.topAnchor, left: contentView.leftAnchor, paddingLeft: 10)
        
        contentView.addSubview(barChart)
        
        barChart.anchor(top: pieChart3.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingRight: 10)
        barChart.heightAnchor.constraint(equalTo: self.barChart.widthAnchor).isActive = true
        
        contentView.addSubview(acceptedLabel)
        acceptedLabel.anchor(top: barChart.topAnchor, left: contentView.leftAnchor, paddingTop: -20, paddingLeft: 10)
        
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
        entries.append(PieChartDataEntry(value: Double(widget.a), label: "Female"))
        entries.append(PieChartDataEntry(value: Double(widget.b), label: "Male"))
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.colorful()
        set.valueColors = [.black]
        set.valueFont = UIFont(name: "Futura", size: 10)!
        set.entryLabelFont = UIFont(name: "Futura", size: 10)!
        set.entryLabelColor = .black
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.chartAnimator.animate(xAxisDuration: 1, yAxisDuration: 1)
        pieChart.legend.font = UIFont(name: "Futura", size: 10)!
        
        entries2.append(PieChartDataEntry(value: Double(widget.c), label: "Mid Atlantic"))
        entries2.append(PieChartDataEntry(value: Double(widget.e), label: "Mid West"))
        entries2.append(PieChartDataEntry(value: Double(widget.g), label: "West"))
        entries2.append(PieChartDataEntry(value: Double(widget.f), label: "South"))
        entries2.append(PieChartDataEntry(value: Double(widget.d), label: "New England"))
        entries2.append(PieChartDataEntry(value: Double(widget.h), label: "International"))
        let set2 = PieChartDataSet(entries: entries2, label: "")
        set2.colors = ChartColorTemplates.joyful()
        set2.valueColors = [.black]
        set2.valueFont = UIFont(name: "Futura", size: 10)!
        set2.entryLabelFont = UIFont(name: "Futura", size: 10)!
        set2.entryLabelColor = .black
        let data2 = PieChartData(dataSet: set2)
        pieChart2.data = data2
        pieChart2.chartAnimator.animate(xAxisDuration: 1, yAxisDuration: 1)
        pieChart2.legend.font = UIFont(name: "Futura", size: 8)!
        
        entries3.append(PieChartDataEntry(value: Double(widget.i), label: "White"))
        entries3.append(PieChartDataEntry(value: Double(widget.j), label: "Black"))
        entries3.append(PieChartDataEntry(value: Double(widget.k), label: "Hispanic"))
        entries3.append(PieChartDataEntry(value: Double(widget.l), label: "Asian"))
        entries3.append(PieChartDataEntry(value: Double(widget.m), label: "International"))
        entries3.append(PieChartDataEntry(value: Double(widget.n), label: "Other"))
        let set3 = PieChartDataSet(entries: entries3, label: "")
        set3.colors = ChartColorTemplates.joyful()
        set3.valueColors = [.black]
        set3.valueFont = UIFont(name: "Futura", size: 10)!
        set3.entryLabelFont = UIFont(name: "Futura", size: 10)!
        set3.entryLabelColor = .black
        let data3 = PieChartData(dataSet: set3)
        pieChart3.data = data3
        pieChart3.chartAnimator.animate(xAxisDuration: 1, yAxisDuration: 1)
        pieChart3.legend.font = UIFont(name: "Futura", size: 10)!
        
        let e1 = (BarChartDataEntry(x: 0, y: Double(widget.p)))
        let e2 = (BarChartDataEntry(x: 1, y: Double(widget.o)))
        let e3 = (BarChartDataEntry(x: 2, y: Double(widget.q)))
        let dataSet = BarChartDataSet(entries: [e1,e2,e3], label: "Number of Students")
        let dataSet2 = BarChartDataSet(entries: [e2], label: "Accepted")
        let dataSet3 = BarChartDataSet(entries: [e3], label: "Enrolled")
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.valueColors = [.black]
        dataSet2.colors = ChartColorTemplates.joyful()
        dataSet2.valueColors = [.black]
        dataSet3.colors = ChartColorTemplates.pastel()
        dataSet3.valueColors = [.black]
    
        let bar = BarChartData(dataSet: dataSet)
        barChart.data = bar
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Applicants", "Accepted", "Enrolled"])
        barChart.xAxis.granularity = 1
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawLabelsEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
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
