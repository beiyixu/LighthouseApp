//
//  FireCodable.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 11/20/20.
//

import UIKit

protocol BaseCodable: AnyObject {
  
  var id: String { get set }
  
}

protocol FireCodable: BaseCodable, Codable {
  
  var id: String { get set }
  
}

protocol FireStorageCodable: FireCodable {
  
  var profilePic: UIImage? { get set }
  var profilePicLink: String? { get set }
  
}
