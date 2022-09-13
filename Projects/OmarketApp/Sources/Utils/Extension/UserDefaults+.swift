//
//  UserDefaults+.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/13.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

extension UserDefaults{
  
  enum Key: String {
    case USER_EMAIL
  }
  
  // MARK: Get
  
  static func getValue<T: Codable>(defaultValue: T, key: Key) -> T {
    guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
      return defaultValue
    }
    
    do {
      return try JSONDecoder.init().decode(T.self, from: data)
    } catch {
      print("UserDefaults saving \(key) Error: \(error)")
    }
    
    return UserDefaults.standard.object(forKey: key.rawValue) as! T
  }
    
  // MARK: Set
  
  static func setValue<T: Codable>(data: T, key: Key) {
    do {
      try UserDefaults.standard.set(JSONEncoder.init().encode(data), forKey: key.rawValue)
    } catch{
      print("UserDefaults saving \(key) Error: \(error)")
    }
  }
  
  // MARK: Clear
  
  static func clearOne(key: Key) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
  static func clearAll() {
    for key in UserDefaults.standard.dictionaryRepresentation().keys {
      UserDefaults.standard.removeObject(forKey: key.description)
    }
  }
}

