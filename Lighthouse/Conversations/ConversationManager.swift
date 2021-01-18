//
//  ConversationManager.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/21/20.
//
//
import Foundation
import Firebase

class ConversationManager {
  
  let service = FirestoreService()
    

  
  func currentConversations(_ completion: @escaping CompletionObject<[ObjectConversation]>) {
    guard let userID = UserManager().currentUserID() else { return }
    let query = FirestoreService.DataQuery(key: "userIDs", value: userID, mode: .contains)
    service.objectWithListener(ObjectConversation.self, parameter: query, reference: .init(location: .conversations)) { results in
      completion(results)
    }
  }
  
  func create(_ conversation: ObjectConversation, _ completion: CompletionObject<FirestoreResponse>? = nil) {
    FirestoreService().update(conversation, reference: .init(location: .conversations)) { completion?($0) }
    let urlString = "https://fcm.googleapis.com/fcm/send"
    let url = NSURL(string: urlString)!
    let conversationUser1 = conversation.userIDs[0]
    var otherConservationUser = ""
    var conversationUser = ""
    if conversationUser1 == Auth.auth().currentUser?.uid {
        otherConservationUser = conversation.userIDs[1]
        conversationUser = conversation.userIDs[0]
    } else {
        otherConservationUser = conversationUser1
        conversationUser = conversation.userIDs[1]
    }
    UserManager().userData(for: otherConservationUser) {[weak self] user in
        UserManager().userData(for: conversationUser) {[weak self] user2 in
      guard let name = user2?.name else { return }
        guard let token = user?.token else { return }
        let paramString: [String : Any] = ["to" : token,
                                           "priority": "high",
                                           "notification" : ["title" : name, "body" : conversation.lastMessage, "sound": "newRecordm4r.caf"],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAJSOxDNM:APA91bHTMiBTWAXiwASmZmQOQl0HnzWNFeyO24R6oH0qwhToFrM7YC4WYbQ7CvlCu4VRJyrhbVy1Xf8BItpcsIS8jkHAMsx1e94HTbbZJmgB7cQFOoHYmXOUf8snmGohkxPw76luaBBV", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    }
    
  }
  
  func markAsRead(_ conversation: ObjectConversation, _ completion: CompletionObject<FirestoreResponse>? = nil) {
    guard let userID = UserManager().currentUserID() else { return }
    guard conversation.isRead[userID] == false else { return }
    conversation.isRead[userID] = true
    FirestoreService().update(conversation, reference: .init(location: .conversations)) { completion?($0) }
  }
    
    func sendMessageToUser(to token: String, title: String, body: String) {
        print("sendMessageTouser()")
        
    }
}
