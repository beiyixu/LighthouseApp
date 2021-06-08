//
//  DateService.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/25/20.
//

import Foundation

class DateService {
    
    // Methods
  
  static let shared = DateService()
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
    private let dateFormatterLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
  
  private init() {}
  
  func format(_ date: Date) -> String {
    return dateFormatter.string(from: date)
  }
    
    func formatLong(_ date: Date) -> String {
        return dateFormatterLong.string(from: date)
    }
}
