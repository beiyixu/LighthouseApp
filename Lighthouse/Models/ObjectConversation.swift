//
//  ObjectConversation.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/12/20.
//

import Foundation

class ObjectConversation: FireCodable {
    
    // Declare Vars
  
  var id = UUID().uuidString
  var userIDs = [String]()
  var timestamp = Int(Date().timeIntervalSince1970)
  var lastMessage: String?
  var isRead = [String: Bool]()
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(userIDs, forKey: .userIDs)
    try container.encode(timestamp, forKey: .timestamp)
    try container.encodeIfPresent(lastMessage, forKey: .lastMessage)
    try container.encode(isRead, forKey: .isRead)
  }
  
    // Object
    
  init() {}
  
  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    userIDs = try container.decode([String].self, forKey: .userIDs)
    timestamp = try container.decode(Int.self, forKey: .timestamp)
    lastMessage = try container.decodeIfPresent(String.self, forKey: .lastMessage)
    isRead = try container.decode([String: Bool].self, forKey: .isRead)
  }
}

extension ObjectConversation {
  private enum CodingKeys: String, CodingKey {
    case id
    case userIDs
    case timestamp
    case lastMessage
    case isRead
  }
}
