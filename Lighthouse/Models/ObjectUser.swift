//
//  ObjectUser.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/12/20.
//

import UIKit

class ObjectUser: FireStorageCodable {
  
  var id = UUID().uuidString
  var name: String?
  var email: String?
  var profilePicLink: String?
  var profilePic: UIImage?
  var password: String?
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(email, forKey: .email)
    try container.encodeIfPresent(profilePicLink, forKey: .profilePicLink)
  }
  
  init() {}
  
  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    email = try container.decodeIfPresent(String.self, forKey: .email)
    profilePicLink = try container.decodeIfPresent(String.self, forKey: .profilePicLink)
  }
}

extension ObjectUser {
  private enum CodingKeys: String, CodingKey {
    case id
    case email
    case name
    case profilePicLink
  }
}
