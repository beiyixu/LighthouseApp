//
//  WidgetResume.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/24/20.
//

import UIKit
import PDFKit
import Firebase

class WidgetResume: UIViewController {
    
    // Declare Vars

    var widget: Widget? {
        didSet {
            configureWidget()
        }
    }
    
    var pdfURL: URL?
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
    private let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Resume"
        view.addSubview(pdfView)
        pdfView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        configureAlertController()

    }
    
    private func configureWidget() {
        guard let widget = widget else { return }
        if widget.user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        }
        guard let url = URL(string: widget.pdfUrl) else { return }
        ThemeService.showLoading(true)
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
                let downloadTask = urlSession.downloadTask(with: url)
                downloadTask.resume()
    }
    
    private func displayPdf() {
        DispatchQueue.main.async {
            let document = PDFDocument(url: self.pdfURL!)
            self.pdfView.document = document
            self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.pdfView.autoScales = true
    }
    }
    

    private func configureAlertController() {
        guard let widget = widget else { return }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
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

}

extension WidgetResume: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            print("downloadLocation:", location)
        ThemeService.showLoading(false)
                // create destination URL with the original pdf name
            guard let url = downloadTask.originalRequest?.url else { return }
            let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
                // delete original copy
            try? FileManager.default.removeItem(at: destinationURL)
                // copy from temp to Document
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
                self.pdfURL = destinationURL
                displayPdf()
            } catch let error {
                print("Copy Error: \(error.localizedDescription)")
            }
        }
}

