//
//  PlaceholderTextView.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/15/20.
//

import UIKit
import ALLoadingView

class ThemeService {
    
    // Methods
  
  static let blueColor = UIColor(red: 129.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1)
  static let purpleColor = UIColor(red: 161.0/255.0, green: 114.0/255.0, blue: 255.0/255.0, alpha: 1)
  
  static func showLoading(_ status: Bool)  {
    if status {
      ALLoadingView.manager.messageText = ""
      ALLoadingView.manager.animationDuration = 1.0
      ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
      return
    }
    ALLoadingView.manager.hideLoadingView()
  }
}
