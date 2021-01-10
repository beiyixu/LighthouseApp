//
//  Post.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/12/20.
//

import Foundation

struct Post {
    
    var id: String
    
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    let postType: Bool
    
    var likes: Int = 0
    var likedByCurrentUser = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.postType = dictionary["postType"] as? Bool ?? false
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}


