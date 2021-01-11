//
//  CustomPickerView.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/19/20.
//

import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
