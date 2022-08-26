//
//  Magpie.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

public struct Magpie<Base> {
  public let base: Base

  public init(_ base: Base) {
    self.base = base
  }
}

public protocol MagpieCompatible: AnyObject {}

extension MagpieCompatible {
  public var mp: Magpie<Self> {
    get { Magpie(self) }
  }
}
