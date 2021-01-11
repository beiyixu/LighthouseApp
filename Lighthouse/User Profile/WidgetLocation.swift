//
//  WidgetLocation.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/18/20.
//

import UIKit
import MapKit
import Firebase

class WidgetLocation: UIViewController {

    private let mapView = MKMapView()
    var locationString: String? {
        didSet {
            setUpMap()
        }
    }
    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        configureAlertController()
    }
    
    private func configureWidget() {
        guard let widget = widget else { return }
        if widget.user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        }
    }
    
    private func setUpMap() {
        guard let location = locationString?.location else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    private func configureAlertController() {
        guard let widget = widget else { return }
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
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
