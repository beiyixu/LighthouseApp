//
//  ContactsPreview.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 12/19/20.
//
//

import UIKit

protocol ContactsPreviewControllerDelegate: AnyObject {
  func contactsPreviewController(didSelect user: ObjectUser)
}

class ContactsPreviewController: UIViewController {
    
    // Declare Vars
  
  @IBOutlet weak var collectionView: UICollectionView!
  weak var delegate: ContactsPreviewControllerDelegate?
  
  private var users = [ObjectUser]()
  private let manager = UserManager()
  
  @IBAction func closePressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let id = manager.currentUserID() else { return }
    manager.contacts {[weak self] results in
      self?.users = results.filter({$0.id != id})
      self?.collectionView.reloadData()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalTransitionStyle = .crossDissolve
    modalPresentationStyle = .overFullScreen
  }
}

extension ContactsPreviewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Collection View
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard !users.isEmpty else {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactsCell.className, for: indexPath) as! ContactsCell
    cell.set(users[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard !users.isEmpty else { return }
    dismiss(animated: true) {
      self.delegate?.contactsPreviewController(didSelect: self.users[indexPath.row])
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard !users.isEmpty else {
      return collectionView.bounds.size
    }
    let width = (collectionView.bounds.width - 30) / 3 //spacing
    return CGSize(width: width, height: width + 30)
  }
}


class ContactsCell: UICollectionViewCell {
    
    // Declare Vars
  
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
    // Reuse Methods
    
  override func prepareForReuse() {
    super.prepareForReuse()
    profilePic.cancelDownload()
    profilePic.image = UIImage(named: "profile pic")
  }
  
  func set(_ user: ObjectUser) {
    nameLabel.text = user.name
    if let urlString = user.profilePicLink {
      profilePic.setImage(url: URL(string: urlString))
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profilePic.layer.cornerRadius = (bounds.width - 10) / 2
  }
}
