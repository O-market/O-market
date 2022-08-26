//
//  DiskStorage.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

final class DiskStorage<T>: Storage {
  let name: String

  init(name: String) {
    self.name = name
  }

  func setObject(_ object: T, forKey key: String) {}
  func value(forKey key: String) -> T? { return nil }
}
