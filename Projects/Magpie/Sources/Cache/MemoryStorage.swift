//
//  MemoryStorage.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

final class MemoryStorage<T: AnyObject>: Storage {
  private let storage = NSCache<NSString, T>()

  func setObject(_ object: T, forKey key: String) {
    storage.setObject(object, forKey: key as NSString)
  }

  func value(forKey key: String) -> T? {
    return storage.value(forKey: key) as? T
  }
}
