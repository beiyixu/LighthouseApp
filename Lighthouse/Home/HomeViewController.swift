//
//  HomeViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/25/20.
//

import UIKit
import Firebase

class HomeController: HomePostCellViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.cellId)
        collectionView?.register(HomeTextCell.self, forCellWithReuseIdentifier: HomeTextCell.cellId)
        collectionView?.backgroundView = HomeEmptyStateView()
        collectionView?.backgroundView?.alpha = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NSNotification.Name.updateHomeFeed, object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh1), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        fetchAllPosts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .systemYellow
        navigationController?.navigationBar.barTintColor = .systemYellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            System.clearNavigationBar(forBar: navBar)
            navBar.backgroundColor = .clear
            let back = UIImageView(image: UIImage(named: "navbar"))
            navBar.addSubview(back)
            back.anchor(top: navBar.superview?.topAnchor, left: navBar.leftAnchor, right: navBar.rightAnchor, height: 125)
            let logo = UIImageView(image: #imageLiteral(resourceName: "logo_white"))
            logo.contentMode = .scaleAspectFit
            let text = UILabel()
            text.font = UIFont.boldSystemFont(ofSize: 50)
            text.text = "Lighthouse"
            text.textAlignment = .left
            text.textColor = .mainBlue
            navBar.addSubview(text)
            text.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, right: navBar.rightAnchor, paddingTop: -10, paddingLeft: 10, paddingRight: 0, height: 60)
            navBar.sendSubviewToBack(back)
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func fetchAllPosts() {
        showEmptyStateViewIfNeeded()
        fetchPostsForCurrentUser()
        fetchFollowingUserPosts()
    }
    
    private func fetchPostsForCurrentUser() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        collectionView?.refreshControl?.beginRefreshing()
        
        Database.database().fetchAllPosts(withUID: currentLoggedInUserId, completion: { (posts) in
            self.posts.append(contentsOf: posts)
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }) { (err) in
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    private func fetchFollowingUserPosts() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        collectionView?.refreshControl?.beginRefreshing()
        
        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (uid, value) in
                
                Database.database().fetchAllPosts(withUID: uid, completion: { (posts) in
                    
                    self.posts.append(contentsOf: posts)
                    
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    self.collectionView?.refreshControl?.endRefreshing()
                    
                }, withCancel: { (err) in
                    self.collectionView?.refreshControl?.endRefreshing()
                })
            })
        }) { (err) in
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    override func showEmptyStateViewIfNeeded() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        Database.database().numberOfFollowingForUser(withUID: currentLoggedInUserId) { (followingCount) in
            Database.database().numberOfPostsForUser(withUID: currentLoggedInUserId, completion: { (postCount) in
                
                if followingCount == 0 && postCount == 0 {
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                        self.collectionView?.backgroundView?.alpha = 1
                    }, completion: nil)
                    
                } else {
                    self.collectionView?.backgroundView?.alpha = 0
                }
            })
        }
    }
    
    @objc private func handleRefresh1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: handleRefresh)
    }
    
    @objc private func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if posts[indexPath.item].postType == true {
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.cellId, for: indexPath) as! HomePostCell
        if indexPath.item < posts.count {
        cell1.post = posts[indexPath.item]
        }
        cell1.delegate = self
        return cell1
        } else {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTextCell.cellId, for: indexPath) as! HomeTextCell
        if indexPath.item < posts.count {
            cell2.post = posts[indexPath.item]
        }
        cell2.delegate = self
        return cell2
        }
                
    }
    
    
}
//MARK: - UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if posts[indexPath.item].postType == true {
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
            
    }
    
}
