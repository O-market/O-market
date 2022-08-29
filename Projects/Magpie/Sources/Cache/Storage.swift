//
//  Storage.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

protocol Storage {
  associatedtype T

  func setObject(_ object: T, forKey key: String)
  func object(forKey key: String) -> T?
}
