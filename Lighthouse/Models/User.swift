//
//  User.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/12/20.
//

import Foundation

struct User {
    
    // Declare Vars
    
    let uid: String
    let username: String
    let profileImageUrl: String?
    let firstName: String
    let lastName: String
    let bio: String
    let instagram: String
    let verified: Bool
    let token: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.instagram = dictionary["instagram"] as? String ?? ""
        self.verified = dictionary["verified"] as? Bool ?? false
        self.token = dictionary["token"] as? String ?? ""
    }
}
