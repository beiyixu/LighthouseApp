//
//  MessageManager.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/21/20.
//
//

import Foundation

class MessageManager {
    
    // Declare Vars
  
  let service = FirestoreService()
  
  func messages(for conversation: ObjectConversation, _ completion: @escaping CompletionObject<[ObjectMessage]>) {
    let reference = FirestoreService.Reference(first: .conversations, second: .messages, id: conversation.id)
    service.objectWithListener(ObjectMessage.self, reference: reference) { results in
      completion(results)
    }
  }
  
  func create(_ message: ObjectMessage, conversation: ObjectConversation, _ completion: @escaping CompletionObject<FirestoreResponse>) {
    FirestorageService().update(message, reference: .messages) { response in
      switch response {
      case .failure: completion(response)
      case .success:
        let reference = FirestoreService.Reference(first: .conversations, second: .messages, id: conversation.id)
        FirestoreService().update(message, reference: reference) { result in
          completion(result)
        }
        if let id = conversation.isRead.filter({$0.key != UserManager().currentUserID() ?? ""}).first {
          conversation.isRead[id.key] = false
        }
        //ConversationManager().create(conversation)
      }
    }
  }
    
    
}
