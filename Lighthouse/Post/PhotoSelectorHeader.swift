//
//  PhotoSelectorHeader.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/13/20.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    // Declare Vars
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    static var headerId = "photoSelectorHeaderId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

}
