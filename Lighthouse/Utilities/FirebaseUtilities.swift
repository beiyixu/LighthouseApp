//
//  FirebaseUtilities.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/15/20.
//

import Foundation
import Firebase
import MapKit

extension Auth {
    //MARK: Auth
    func createUser(withEmail email: String, username: String, password: String, image: UIImage?, completion: @escaping (Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create user:", err)
                completion(err)
                return
            }
            guard let uid = user?.user.uid else { return }
            if let image = image {
                Storage.storage().uploadUserProfileImage(image: image, completion: { (profileImageUrl) in
                    self.uploadUser(withUID: uid, username: username, profileImageUrl: profileImageUrl) {
                        completion(nil)
                    }
                    let user = ObjectUser()
                    user.profilePicLink = profileImageUrl
                    user.id = uid
                    user.name = username
                    UserManager().update(user: user, completion: { result in
                    })
                })
                
            } else {
                self.uploadUser(withUID: uid, username: username) {
                    completion(nil)
                }
                let user = ObjectUser()
                user.id = uid
                user.name = username
                UserManager().update(user: user, completion: { result in
                    completion(nil)
                })
               
            }
        })
        
    }
    
    private func uploadUser(withUID uid: String, username: String, profileImageUrl: String? = nil, completion: @escaping (() -> ())) {
        var dictionaryValues = ["username": username]
        let dicValues = [uid: username]
        if profileImageUrl != nil {
            dictionaryValues["profileImageUrl"] = profileImageUrl
        }
        
        let values = [uid: dictionaryValues]
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            Database.database().reference().child("usernames").updateChildValues(dicValues)
            completion()
        })
    }
    
    func updateUser(withUID uid: String, firstName: String, lastName: String, bio: String, completion: @escaping (Error?) -> ()) {
        
        ThemeService.showLoading(true)
        let dictionaryValues = [ "firstName": firstName, "lastName": lastName, "bio": bio]
        Database.database().reference().child("users").child(uid).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
            ThemeService.showLoading(false)
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
            
        })
        
    }
    
    func updateUser2(withUID uid: String, firstName: String, lastName: String, bio: String, instagram: String, completion: @escaping (Error?) -> ()) {
        
        ThemeService.showLoading(true)
        let dictionaryValues = [ "firstName": firstName, "lastName": lastName, "bio": bio, "instagram": instagram]
        Database.database().reference().child("users").child(uid).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
            ThemeService.showLoading(false)
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
            
        })
        
    }
    
    
}

extension Storage {
    //MARK: Storage
    
    fileprivate func uploadUserProfileImage(image: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 1) else { return }
        
        let storageRef = Storage.storage().reference().child("profile_images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for profile image:", err)
                    return
                }
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                completion(profileImageUrl)
            })
        })
    }
    
    fileprivate func uploadPostImage(image: UIImage, filename: String, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 1) else { return }
        
        let storageRef = Storage.storage().reference().child("post_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for post image:", err)
                    return
                }
                guard let postImageUrl = downloadURL?.absoluteString else { return }
                completion(postImageUrl)
            })
        })
    }
    
    fileprivate func uploadWidgetPdf(pdf: URL, filename: String, completion: @escaping (String) -> ()) {
        
        let storageRef = Storage.storage().reference().child("widget_pdf").child(filename)
        storageRef.putFile(from: pdf, metadata: nil) { (_, err) in
            if let err = err {
                print("Failed to upload:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url:", err)
                    return
                }
                guard let pdfUrl = downloadURL?.absoluteString else { return }
                completion(pdfUrl)
            })
        }
    }
}

extension Database {

    //MARK: Database
    
    func fetchUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchUserData(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchAllUsers(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach({ (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            })
            
            users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            completion(users)
            
        }) { (err) in
            print("Failed to fetch all users from database:", (err))
            cancel?(err)
        }
    }
    
    func isFollowingUser(withUID uid: String, completion: @escaping (Bool) -> (), withCancel cancel: ((Error) -> ())?) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (err) in
            print("Failed to check if following:", err)
            cancel?(err)
        }
    }
    
    func isConvo(withUID uid: String, completion: @escaping (Bool) -> (), withCancel cancel: ((Error) -> ())?) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("conversationz").child(currentLoggedInUserId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (err) in
            print("Failed to check if following:", err)
            cancel?(err)
        }
    }
    
    func followUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: 1]
        Database.database().reference().child("following").child(currentLoggedInUserId).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            
            let values = [currentLoggedInUserId: 1]
            Database.database().reference().child("followers").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func unfollowUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).removeValue { (err, _) in
            if let err = err {
                print("Failed to remove user from following:", err)
                completion(err)
                return
            }
            
            Database.database().reference().child("followers").child(uid).child(currentLoggedInUserId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to remove user from followers:", err)
                    completion(err)
                    return
                }
                completion(nil)
            })
        }
    }
    
    func createPost(withImage image: UIImage, caption: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        
        Storage.storage().uploadPostImage(image: image, filename: postId) { (postImageUrl) in
            let values = ["imageUrl": postImageUrl, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": true] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func createPostNoImage(caption: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        let values = ["caption": caption, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": false] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }
    
    func createWidget(question: String, answer: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        let values = ["question": question, "answer": answer, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }
    
    func createWidget5(question: String, location: CLLocationCoordinate2D, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        let location1 = location.string
        guard let postId = userPostRef.key else { return }
        let values = ["question": question, "location": location1, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 4] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }
    
    func createWidget6(question: String, pdf: URL, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        
        Storage.storage().uploadWidgetPdf(pdf: pdf, filename: postId) { (pdfUrl) in
            let values = ["question": "Resume", "pdfUrl": pdfUrl, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 6] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
        
    }
    
    func createWidget4(question: String, gpa: String, actR: String, actE: String, actM: String, actS: String, satM: String, satR: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let GPA1 = Double(gpa) ?? 0
        let ACT1 = Int(actE) ?? 0
        let ACT2 = Int(actR) ?? 0
        let ACT3 = Int(actM) ?? 0
        let ACT4 = Int(actS) ?? 0
        let SAT1 = Int(satM) ?? 0
        let SAT2 = Int(satR) ?? 0
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        let values = ["question": question, "a": GPA1, "b": ACT1,"c":ACT2,"d":ACT3, "e":ACT4, "f": SAT1, "g": SAT2, "postType": 5, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                Database.database().reference().child("users").child(uid).child("data").updateChildValues(["gpa": GPA1, "actEnglish": ACT1,"actReading":ACT2,"actMath":ACT3, "actScience":ACT4, "satMath": SAT1, "satReading": SAT2]) { (err, ref) in
                    if let err = err {
                        print("Failed to save post to database", err)
                        completion(err)
                        return
                    }
                    completion(nil)
                }
            }
        
    }
    
    func createWidget2(male: String, female: String, midAtlantic: String, newEngland: String, midWest: String, south: String, west: String, international: String, white: String, black: String, hispanic: String, asian: String, internationalEthnicity: String, other: String, accepted: String, applicants: String, enrolled: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        let male1 = Int(male) ?? 0
        let female1 = Int(female) ?? 0
        let midAtlantic1 = Int(midAtlantic) ?? 0
        let newEngland1 = Int(newEngland) ?? 0
        let midWest = Int(midWest) ?? 0
        let south1 = Int(south) ?? 0
        let west1 = Int(west) ?? 0
        let international1 = Int(international) ?? 0
        let white1 = Int(white) ?? 0
        let black1 = Int(black) ?? 0
        let hispanic1 = Int(hispanic) ?? 0
        let asian1 = Int(asian) ?? 0
        let internationalEthnicity1 = Int(internationalEthnicity) ?? 0
        let other1 = Int(other) ?? 0
        let accepted1 = Int(accepted) ?? 0
        let applicants1 = Int(applicants) ?? 0
        let enrolled1 = Int(enrolled) ?? 0
        
        guard let postId = userPostRef.key else { return }
        let values = ["a": male1, "b": female1, "c": midAtlantic1, "d": newEngland1, "e": midWest, "f": south1, "g": west1, "h": international1, "i": white1, "j": black1, "k": hispanic1, "l": asian1, "m": internationalEthnicity1, "n": other1, "o": accepted1, "p": applicants1, "q": enrolled1,"creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 2, "question": "Demographics"] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }
    
    func createWidget3(sat25math: String, sat75math: String, sat25reading: String, sat75reading: String, act25reading: String, act75reading: String, act25math: String, act75math: String, act25science: String, act75science: String, act25english: String, act75english: String, gpa: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).childByAutoId()
        let sat25math1 = Int(sat25math) ?? 0
        let sat75math1 = Int(sat75math) ?? 0
        let sat25reading1 = Int(sat25reading) ?? 0
        let sat75reading1 = Int(sat75reading) ?? 0
        let act25reading1 = Int(act25reading) ?? 0
        let act75reading1 = Int(act75reading) ?? 0
        let act25math1 = Int(act25math) ?? 0
        let act75math1 = Int(act75math) ?? 0
        let act25science1 = Int(act25science) ?? 0
        let act75science1 = Int(act75science) ?? 0
        let act25english1 = Int(act25english) ?? 0
        let act75english1 = Int(act75english) ?? 0
        let gpa1 = Double(gpa) ?? 0
        
        guard let postId = userPostRef.key else { return }
        let values = ["a": sat25math1, "b": sat75math1, "c": sat25reading1, "d": sat75reading1, "e": act25reading1, "f": act75reading1, "g": act25math1, "h": act75math1, "i": act25science1, "j": act75science1, "k": act25english1, "l": act75english1, "m": gpa1, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 3, "question": "Test Scores"] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }

    
    func fetchPost(withUID uid: String, postId: String, completion: @escaping (Post) -> (), withCancel cancel: ((Error) -> ())? = nil) {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid).child(postId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let postDictionary = snapshot.value as? [String: Any] else { return }
            
            Database.database().fetchUser(withUID: uid, completion: { (user) in
                var post = Post(user: user, dictionary: postDictionary)
                post.id = postId
                
                //check likes
                Database.database().reference().child("likes").child(postId).child(currentLoggedInUser).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.likedByCurrentUser = true
                    } else {
                        post.likedByCurrentUser = false
                    }
                    
                    Database.database().numberOfLikesForPost(withPostId: postId, completion: { (count) in
                        post.likes = count
                        completion(post)
                    })
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                    cancel?(err)
                })
            })
        })
    }
    
    func fetchAllPosts(withUID uid: String, completion: @escaping ([Post]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }

            var posts = [Post]()

            dictionaries.forEach({ (postId, value) in
                Database.database().fetchPost(withUID: uid, postId: postId, completion: { (post) in
                    posts.append(post)
                    
                    if posts.count == dictionaries.count {
                        completion(posts)
                    }
                })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
            cancel?(err)
        }
    }
    
    
    
  
    
    func fetchWidget(withUID uid: String, widgetId: String, completion: @escaping (Widget) -> (), withCancel cancel: ((Error) -> ())? = nil) {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("widgets").child(uid).child(widgetId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let widgetDictionary = snapshot.value as? [String: Any] else { return }
            
            Database.database().fetchUser(withUID: uid, completion: { (user) in
                var widget = Widget(user: user, dictionary: widgetDictionary)
                widget.id = widgetId
                completion(widget)
                
            })
        })
         
    }
    
    
    func fetchAllWidgets(withUID uid: String, completion: @escaping ([Widget]) -> (), withCancel cancel: ((Error) -> ())?) {
        
        
        let ref = Database.database().reference().child("widgets").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }

            var widgets = [Widget]()

            dictionaries.forEach({ (widgetId, value) in
                Database.database().fetchWidget(withUID: uid, widgetId: widgetId, completion: { (widget) in
                    widgets.append(widget)
                    
                    if widgets.count == dictionaries.count {
                        completion(widgets)
                    }
                })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
            cancel?(err)
        }
        
       
    }
    
    func deletePost(withUID uid: String, postId: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("posts").child(uid).child(postId).removeValue { (err, _) in
            if let err = err {
                print("Failed to delete post:", err)
                completion?(err)
                return
            }
            
            Database.database().reference().child("comments").child(postId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to delete comments on post:", err)
                    completion?(err)
                    return
                }
                
                Database.database().reference().child("likes").child(postId).removeValue(completionBlock: { (err, _) in
                    if let err = err {
                        print("Failed to delete likes on post:", err)
                        completion?(err)
                        return
                    }
                    
                    Storage.storage().reference().child("post_images").child(postId).delete(completion: { (err) in
                        if let err = err {
                            print("Failed to delete post image from storage:", err)
                            completion?(err)
                            return
                        }
                    })
                    
                    completion?(nil)
                })
            })
        }
        
    }
    func deleteWidget(withUID uid: String, postId: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("widgets").child(uid).child(postId).removeValue { (err, _) in
            if let err = err {
                print("Failed to delete post:", err)
                completion?(err)
                return
            }
            completion?(nil)
        }
    }
    
    func addCommentToPost(withId postId: String, text: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        let commentsRef = Database.database().reference().child("comments").child(postId).childByAutoId()
        commentsRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add comment:", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    func fetchCommentsForPost(withId postId: String, completion: @escaping ([Comment]) -> (), withCancel cancel: ((Error) -> ())?) {
        let commentsReference = Database.database().reference().child("comments").child(postId)
        
        commentsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var comments = [Comment]()
            
            dictionaries.forEach({ (key, value) in
                guard let commentDictionary = value as? [String: Any] else { return }
                guard let uid = commentDictionary["uid"] as? String else { return }
                
                Database.database().fetchUser(withUID: uid) { (user) in
                    let comment = Comment(user: user, dictionary: commentDictionary)
                    comments.append(comment)
                    
                    if comments.count == dictionaries.count {
                        comments.sort(by: { (comment1, comment2) -> Bool in
                            return comment1.creationDate.compare(comment2.creationDate) == .orderedAscending
                        })
                        completion(comments)
                    }
                }
            })
            
        }) { (err) in
            print("Failed to fetch comments:", err)
            cancel?(err)
        }
    }
    
    func fetchConvos(withId convoId: String, completion: @escaping ([Comment]) -> (), withCancel cancel: ((Error) -> ())?) {
        let commentsReference = Database.database().reference().child("conversations").child(convoId).child("messages")
        
        commentsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var comments = [Comment]()
            
            dictionaries.forEach({ (key, value) in
                guard let commentDictionary = value as? [String: Any] else { return }
                guard let uid = commentDictionary["uid"] as? String else { return }
                
                Database.database().fetchUser(withUID: uid) { (user) in
                    let comment = Comment(user: user, dictionary: commentDictionary)
                    comments.append(comment)
                    
                    if comments.count == dictionaries.count {
                        comments.sort(by: { (comment1, comment2) -> Bool in
                            return comment1.creationDate.compare(comment2.creationDate) == .orderedAscending
                        })
                        completion(comments)
                    }
                }
            })
            
        }) { (err) in
            print("Failed to fetch comments:", err)
            cancel?(err)
        }
    }
    
    func addConvo(withId convoId: String, text: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        let commentsRef = Database.database().reference().child("conversations").child(convoId).child("messages").childByAutoId()
        commentsRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add comment:", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    
    
    //MARK: Utilities
    
    func numberOfPostsForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("posts").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func numberOfFollowersForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("followers").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func numberOfFollowingForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func numberOfLikesForPost(withPostId postId: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("likes").child(postId).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func updateWidget(withUID uid: String, postId: String, question: String, answer: String, completion: @escaping (Error?) -> ()) {
        
        ThemeService.showLoading(true)
        let dictionaryValues = ["question": question, "answer": answer]
        Database.database().reference().child("widgets").child(uid).child(postId).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
            ThemeService.showLoading(false)
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
            
        })
        
    }
    
    func updateWidget2(withUID uid: String, postId: String, male: String, female: String, midAtlantic: String, newEngland: String, midWest: String, south: String, west: String, international: String, white: String, black: String, hispanic: String, asian: String, internationalEthnicity: String, other: String, accepted: String, applicants: String, enrolled: String, completion: @escaping (Error?) -> ()) {
        let male1 = Int(male) ?? 0
        let female1 = Int(female) ?? 0
        let midAtlantic1 = Int(midAtlantic) ?? 0
        let newEngland1 = Int(newEngland) ?? 0
        let midWest = Int(midWest) ?? 0
        let south1 = Int(south) ?? 0
        let west1 = Int(west) ?? 0
        let international1 = Int(international) ?? 0
        let white1 = Int(white) ?? 0
        let black1 = Int(black) ?? 0
        let hispanic1 = Int(hispanic) ?? 0
        let asian1 = Int(asian) ?? 0
        let internationalEthnicity1 = Int(internationalEthnicity) ?? 0
        let other1 = Int(other) ?? 0
        let accepted1 = Int(accepted) ?? 0
        let applicants1 = Int(applicants) ?? 0
        let enrolled1 = Int(enrolled) ?? 0
        let dictionaryValues = ["a": male1, "b": female1, "c": midAtlantic1, "d": newEngland1, "e": midWest, "f": south1, "g": west1, "h": international1, "i": white1, "j": black1, "k": hispanic1, "l": asian1, "m": internationalEthnicity1, "n": other1, "o": accepted1, "p": applicants1, "q": enrolled1,"creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 2, "question": "Demographics"] as [String : Any]
        ThemeService.showLoading(true)
        Database.database().reference().child("widgets").child(uid).child(postId).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
            ThemeService.showLoading(false)
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
            
        })
        
    }
    
    func updateWidget4(uid: String, postId: String, gpa: String, actR: String, actE: String, actM: String, actS: String, satM: String, satR: String, completion: @escaping (Error?) -> ()) {
        
        let GPA1 = Double(gpa) ?? 0
        let ACT1 = Int(actE) ?? 0
        let ACT2 = Int(actR) ?? 0
        let ACT3 = Int(actM) ?? 0
        let ACT4 = Int(actS) ?? 0
        let SAT1 = Int(satM) ?? 0
        let SAT2 = Int(satR) ?? 0
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).child(postId)
        
        let values = ["a": GPA1, "b": ACT1,"c":ACT2,"d":ACT3, "e":ACT4, "f": SAT1, "g": SAT2, "postType": 5, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                Database.database().reference().child("users").child(uid).child("data").updateChildValues(["gpa": GPA1, "actEnglish": ACT1,"actReading":ACT2,"actMath":ACT3, "actScience":ACT4, "satMath": SAT1, "satReading": SAT2]) { (err, ref) in
                    if let err = err {
                        print("Failed to save post to database", err)
                        completion(err)
                        return
                    }
                    completion(nil)
                }
            }
        
    }
    
    func updateWidget3(uid: String, postId: String, sat25math: String, sat75math: String, sat25reading: String, sat75reading: String, act25reading: String, act75reading: String, act25math: String, act75math: String, act25science: String, act75science: String, act25english: String, act75english: String, gpa: String, completion: @escaping (Error?) -> ()) {
        
        let userPostRef = Database.database().reference().child("widgets").child(uid).child(postId)
        let sat25math1 = Int(sat25math) ?? 0
        let sat75math1 = Int(sat75math) ?? 0
        let sat25reading1 = Int(sat25reading) ?? 0
        let sat75reading1 = Int(sat75reading) ?? 0
        let act25reading1 = Int(act25reading) ?? 0
        let act75reading1 = Int(act75reading) ?? 0
        let act25math1 = Int(act25math) ?? 0
        let act75math1 = Int(act75math) ?? 0
        let act25science1 = Int(act25science) ?? 0
        let act75science1 = Int(act75science) ?? 0
        let act25english1 = Int(act25english) ?? 0
        let act75english1 = Int(act75english) ?? 0
        let gpa1 = Double(gpa) ?? 0
        
        guard let postId = userPostRef.key else { return }
        let values = ["a": sat25math1, "b": sat75math1, "c": sat25reading1, "d": sat75reading1, "e": act25reading1, "f": act75reading1, "g": act25math1, "h": act75math1, "i": act25science1, "j": act75science1, "k": act25english1, "l": act75english1, "m": gpa1, "creationDate": Date().timeIntervalSince1970, "id": postId, "postType": 3, "question": "Test Scores"] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        
    }
}
