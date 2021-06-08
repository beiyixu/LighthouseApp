//
//  ConsersationsViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 12/17/20.
//
//

import UIKit

class ConversationsViewController: UIViewController {
  
    // Declare Vars
    
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profileImageView: UIImageView!
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  private var conversations = [ObjectConversation]()
  private let manager = ConversationManager()
  private let userManager = UserManager()
  private var currentUser: ObjectUser?
  
  // Methods
    
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(fetchConversations), name: NSNotification.Name.updateConvos, object: nil)
    fetchProfile()
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(fetchConversations), for: .valueChanged)
    tableView?.refreshControl = refreshControl
    navigationController?.navigationBar.barTintColor = .systemYellow
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.setNavigationBarHidden(true, animated: true)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
    
  
}

extension ConversationsViewController {
  
  @IBAction func composePressed(_ sender: Any) {
    let vc: ContactsPreviewController = UIStoryboard.controller(storyboard: .previews)
    vc.delegate = self
    present(vc, animated: true, completion: nil)
  }
}

extension ConversationsViewController {
  
  @objc func fetchConversations() {
    conversations.removeAll()
    manager.currentConversations {[weak self] conversations in
      self?.conversations = conversations.sorted(by: {$0.timestamp > $1.timestamp})
      self?.tableView.reloadData()
        self?.tableView?.refreshControl?.endRefreshing()
      self?.playSoundIfNeeded()
    }
  }
  
  func fetchProfile() {
    userManager.currentUserData {[weak self] user in
      self?.currentUser = user
      if let urlString = user?.profilePicLink {
        self?.profileImageView.setImage(url: URL(string: urlString))
      }
    }
    fetchConversations()
  }
  
  func playSoundIfNeeded() {
    guard let id = userManager.currentUserID() else { return }
    if conversations.last?.isRead[id] == false {
      AudioService().playSound()
    }
  }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if conversations.isEmpty {
      return 1
    }
    return conversations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard !conversations.isEmpty else {
      return tableView.dequeueReusableCell(withIdentifier: "EmptyCell")!
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.className) as! ConversationCell
    cell.set(conversations[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if conversations.isEmpty {
      composePressed(self)
      return
    }
    let vc: MessagesViewController = UIStoryboard.initial(storyboard: .messages)
    vc.modalPresentationStyle = .fullScreen
    vc.conversation = conversations[indexPath.row]
    manager.markAsRead(conversations[indexPath.row])
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if conversations.isEmpty {
      return tableView.bounds.height - 50 //header view height
    }
    return 80
  }
}

extension ConversationsViewController: ContactsPreviewControllerDelegate {
  func contactsPreviewController(didSelect user: ObjectUser) {
    guard let currentID = userManager.currentUserID() else { return }
    let vc: MessagesViewController = UIStoryboard.initial(storyboard: .messages)
    if let conversation = conversations.filter({$0.userIDs.contains(user.id)}).first {
      vc.conversation = conversation
      show(vc, sender: self)
      return
    }
    let conversation = ObjectConversation()
    conversation.userIDs.append(contentsOf: [currentID, user.id])
    conversation.isRead = [currentID: true, user.id: true]
    vc.conversation = conversation
    show(vc, sender: self)
  }
}
