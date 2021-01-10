//
//  UserProfileController.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/12/20.
//

import UIKit
import Firebase

class UserProfileController: HomePostCellViewController {
    
    var user: User? {
        didSet {
            configureUser()
        }
    }
    
    private var header: UserProfileHeader?
    
    private let alertController: UIAlertController = {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        return ac
    }()
    
//    private var isFinishedPaging = false
//    private var pagingCount: Int = 4
    
    private var isGridView: Bool = false
    
    private var isWidgetView: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.barTintColor = .systemYellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NSNotification.Name.updateUserProfileFeed, object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.headerId)
        collectionView?.register(UserProfilePhotoGridCell.self, forCellWithReuseIdentifier: UserProfilePhotoGridCell.cellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.cellId)
        collectionView?.register(UserProfileEmptyStateCell.self, forCellWithReuseIdentifier: UserProfileEmptyStateCell.cellId)
        collectionView?.register(HomeTextCell.self, forCellWithReuseIdentifier: HomeTextCell.cellId)
        collectionView?.register(UserProfileTextGridCell.self, forCellWithReuseIdentifier: UserProfileTextGridCell.cellId)
        collectionView?.register(WidgetsCell.self, forCellWithReuseIdentifier: WidgetsCell.cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        self.header?.reloadData()
        
        configureAlertController()
    }
    
    private func configureAlertController() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let err {
                print("Failed to sign out:", err)
            }
        }
        alertController.addAction(logOutAction)
        
    }
    
    private func configureUser() {
        guard let user = user else { return }
        
        if user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
            let navLabel: UILabel = {
                let label = UILabel()
                label.text = user.username
                label.textColor = .black
                label.textAlignment = .left
                label.font = UIFont.boldSystemFont(ofSize: 40)
                label.textColor = .mainBlue
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            self.navigationItem.titleView = navLabel
        } else {
            let optionsButton = UIBarButtonItem(title: "•••", style: .plain, target: nil, action: nil)
            optionsButton.tintColor = .black
            navigationItem.rightBarButtonItem = optionsButton
            
            navigationItem.title = user.username
            
        }
            
        
        header?.user = user
        
        handleRefresh()
    }
    
    @objc private func handleSettings() {
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleRefresh() {
        guard let uid = user?.uid else { return }
        
        posts.removeAll()
        widgets.removeAll()
        
        Database.database().fetchAllPosts(withUID: uid, completion: { (posts) in
            self.posts = posts
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            Database.database().fetchAllWidgets(withUID: uid, completion: { (widgets) in
                self.widgets = widgets
                self.collectionView?.reloadData()
                self.collectionView?.refreshControl?.endRefreshing()
                
            }) { (err) in
                self.collectionView?.refreshControl?.endRefreshing()
            }
        }) { (err) in
            self.collectionView?.refreshControl?.endRefreshing()
        }
        
        header?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isWidgetView && widgets.count != 0 {
            return widgets.count
        } else if isWidgetView && widgets.count == 0 {
            return 1
        } else if isWidgetView == false && posts.count == 0 {
            return 1
        } else {
            return posts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isWidgetView {
            if widgets.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileEmptyStateCell.cellId, for: indexPath)
                return cell
            }
            if widgets[indexPath.item].id != "" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetsCell.cellId, for: indexPath) as! WidgetsCell
            cell.widget = widgets[indexPath.item]
                cell.delegate = self
            return cell
            }
        }
        if isWidgetView == false {
        if posts.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileEmptyStateCell.cellId, for: indexPath)
            return cell
        }
        let item = posts[indexPath.item].postType
        if item == true {
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoGridCell.cellId, for: indexPath) as! UserProfilePhotoGridCell
            cell.post = posts[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
        } else if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileTextGridCell.cellId, for: indexPath) as! UserProfileTextGridCell
            cell.post = posts[indexPath.item]
            cell.delegate = self
            return cell
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTextCell.cellId, for: indexPath) as! HomeTextCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
        }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileEmptyStateCell.cellId, for: indexPath)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if header == nil {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.headerId, for: indexPath) as? UserProfileHeader
            header?.delegate = self
            header?.user = user
        }
        return header!
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
    
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isGridView || isWidgetView {
            return 1
            } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isGridView || isWidgetView {
        return 1 }
    else {
        return 30
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isWidgetView == true && widgets.count == 0 {
            let emptyStateCellHeight = (view.safeAreaLayoutGuide.layoutFrame.height - 200)
            return CGSize(width: view.frame.width, height: emptyStateCellHeight)
        }
        if isWidgetView == false && posts.count == 0 {
            let emptyStateCellHeight = (view.safeAreaLayoutGuide.layoutFrame.height - 200)
            return CGSize(width: view.frame.width, height: emptyStateCellHeight)
        }
        if (isGridView && posts.count != 0) || isWidgetView {
            let width = (view.frame.width - 2) / 2
            return CGSize(width: width, height: width)
        }
        if isWidgetView == false {
            if posts.count == 0 {
                let emptyStateCellHeight = (view.safeAreaLayoutGuide.layoutFrame.height - 200)
                return CGSize(width: view.frame.width, height: emptyStateCellHeight)
            }
        let item = posts[indexPath.item].postType
        
        if item == true {
            
        let dummyCell = HomePostCell(frame: CGRect(x: 0, y: 0, width: view.frame.width - 200, height: 900))
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        var height: CGFloat = dummyCell.header.bounds.height
        height += view.frame.width
        height += 24 + 2 * dummyCell.padding //bookmark button + padding
        height += dummyCell.captionLabel.intrinsicContentSize.height + 8
        return CGSize(width: view.frame.width - 20, height: height + 30)
        } else {
        let dummyCell = HomeTextCell(frame: CGRect(x: 0, y: 0, width: view.frame.width - 200, height: 500))
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
            
        var height: CGFloat = dummyCell.header.bounds.height
        height += 24 + 2 * dummyCell.padding //bookmark button + padding
        height += dummyCell.captionLabel.intrinsicContentSize.height + 8
        return CGSize(width: view.frame.width - 20, height: height + 30)
        }
        } else {
            return CGSize(width: view.frame.width, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 450)
    }
}

//MARK: - UserProfileHeaderDelegate

extension UserProfileController: UserProfileHeaderDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        isWidgetView = false
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        isWidgetView = false
        collectionView?.reloadData()
    }
    
    func didChangeToWidgetView() {
        isGridView = false
        isWidgetView = true
        collectionView?.reloadData()
    }
    
    func didPressEdit() {
        let commentsController = UserEdit()
        commentsController.user = user
        let nav = UINavigationController(rootViewController: commentsController)
        present(nav, animated: true, completion: nil)
    }
}

