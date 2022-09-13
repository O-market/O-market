//
//  UserDefaultsManager.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/13.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

enum UserDefaultsManager {
  static let defaultString = ""
  
  static var USER_EMAIL: String {
    get{
      UserDefaults.getValue(defaultValue: Self.defaultString, key: .USER_EMAIL)
    }
    set(value){
      UserDefaults.setValue(data: value, key: .USER_EMAIL)
    }
  }
  
  static func clearOne(key: UserDefaults.Key){
    UserDefaults.clearOne(key: key)
  }
  
  static func clearAll(){
    UserDefaults.clearAll()
  }
}
