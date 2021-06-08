//
//  CameraController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/17/20.
//
//

import UIKit
import AVFoundation
import Photos

class CameraController: UIViewController {
    
    // Declare Vars
    
    private var selectedImage : UIImage?
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "forward_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    private let customAnimationPresentor = CustomAnimationPresentor()
    private let customAnimationDismissor = CustomAnimationDismissor()
    
    private let output = AVCapturePhotoOutput()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        transitioningDelegate = self
        setupCaptureSession()
        setupHUD()
    }
    
    private func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
    }
    
    private func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        let captureSession = AVCaptureSession()
        
        //setup inputs
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not set up camera input:", err)
        }
        
        //setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.safeAreaLayoutGuide.layoutFrame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    @objc private func handleDismiss() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func handleCapturePhoto() {
       let settings = AVCapturePhotoSettings()
        
        // do not execute camera capture for simulator
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let previewImage = UIImage(data: imageData)
        selectedImage = UIImage(data: imageData)
         
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        view.addSubview(nextButton)
        nextButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 44, height: 44)
    
    }
    
    
    @objc private func handleNext() {
        
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = selectedImage
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension CameraController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismissor
    }
}



