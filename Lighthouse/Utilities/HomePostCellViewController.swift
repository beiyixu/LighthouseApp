//
//  HomePostCellViewController.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/13/20.
//

import UIKit
import Firebase
import EventKit
import EventKitUI

class HomePostCellViewController: UICollectionViewController, HomePostCellDelegate, HomeTextCellDelegate, UserProfileTextGridCellDelegate, WidgetsCellDelegate, HomeEventCellDelegate {
    
    var posts = [Post]()
    
    var widgets = [Widget]()
    
    let eventStore = EKEventStore()
    var time = Date()
    
    func showEmptyStateViewIfNeeded() {}
    
    //MARK: - HomePostCellDelegate
    
    func didTapResume(widget: Widget) {
        let controller = WidgetResume()
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapLocation(widget: Widget) {
        let controller = WidgetLocation()
        controller.locationString = widget.location
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapChart(widget: Widget) {
        let controller = WidgetChartView()
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapTest(widget: Widget) {
        let controller = WidgetTest()
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapUserTest(widget: Widget) {
        let controller = WidgetUserTest()
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapWidget(widget: Widget) {
        let controller = WidgetView()
        controller.widget = widget
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didTapEvent(post: Post) {
        
        print(post.startDate)
              print(post.endDate)
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
                    DispatchQueue.main.async {
                        if (granted) && (error == nil) {
                            let event = EKEvent(eventStore: self.eventStore)
                            event.title = post.title
                            event.startDate = Date(timeIntervalSince1970: post.startDate)
                            event.url = URL(string: "https://lighthouse-app.com")
                            event.endDate = Date(timeIntervalSince1970: post.endDate)
                            event.notes = post.caption
                            let eventController = EKEventEditViewController()
                            eventController.event = event
                            eventController.eventStore = self.eventStore
                            eventController.editViewDelegate = self
                            self.present(eventController, animated: true, completion: nil)
                            
                        }
                    }
                })
    }
    
    func didTapUser(user: User) {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    func didTapOptions(post: Post) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if currentLoggedInUserId == post.user.uid {
            if let deleteAction = deleteAction(forPost: post) {
                alertController.addAction(deleteAction)
            }
        } else {
            if let unfollowAction = unfollowAction(forPost: post) {
                alertController.addAction(unfollowAction)
            }
        }
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAction(forPost post: Post) -> UIAlertAction? {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return nil }
        
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            let alert = UIAlertController(title: "Delete Post?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                
                Database.database().deletePost(withUID: currentLoggedInUserId, postId: post.id) { (_) in
                    if let postIndex = self.posts.firstIndex(where: {$0.id == post.id}) {
                        self.posts.remove(at: postIndex)
                        self.collectionView?.reloadData()
                        self.showEmptyStateViewIfNeeded()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })
        return action
    }
    
    private func unfollowAction(forPost post: Post) -> UIAlertAction? {
        let action = UIAlertAction(title: "Unfollow", style: .destructive) { (_) in
            
            let uid = post.user.uid
            Database.database().unfollowUser(withUID: uid, completion: { (_) in
                let filteredPosts = self.posts.filter({$0.user.uid != uid})
                self.posts = filteredPosts
                self.collectionView?.reloadData()
                self.showEmptyStateViewIfNeeded()
            })
        }
        return action
    }
    
    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = posts[indexPath.item]
        
        if post.likedByCurrentUser {
            Database.database().reference().child("likes").child(post.id).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.likedByCurrentUser = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        } else {
            let values = [uid : 1]
            Database.database().reference().child("likes").child(post.id).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.likedByCurrentUser = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    func didLike(for cell: HomeEventCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = posts[indexPath.item]
        
        if post.likedByCurrentUser {
            Database.database().reference().child("likes").child(post.id).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.likedByCurrentUser = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        } else {
            let values = [uid : 1]
            Database.database().reference().child("likes").child(post.id).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.likedByCurrentUser = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    func didLike(for cell: UserProfileTextGridCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = posts[indexPath.item]
        
        if post.likedByCurrentUser {
            Database.database().reference().child("likes").child(post.id).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.likedByCurrentUser = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        } else {
            let values = [uid : 1]
            Database.database().reference().child("likes").child(post.id).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.likedByCurrentUser = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    func didLike(for cell: HomeTextCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = posts[indexPath.item]
        
        if post.likedByCurrentUser {
            Database.database().reference().child("likes").child(post.id).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.likedByCurrentUser = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        } else {
            let values = [uid : 1]
            Database.database().reference().child("likes").child(post.id).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.likedByCurrentUser = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }
    }
}

extension HomePostCellViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
