//
//  Post.swift
//  Lighthouse
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
    let postType: Int
    let title: String
    let startDate: Double
    let endDate: Double
    
    var likes: Int = 0
    var likedByCurrentUser = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.postType = dictionary["postType"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.startDate = dictionary["startDate"] as? Double ?? 0
        self.endDate = dictionary["endDate"] as? Double ?? 0
        
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}


