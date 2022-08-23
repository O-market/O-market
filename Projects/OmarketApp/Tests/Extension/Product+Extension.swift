//
//  Product+Extension.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

extension Product: Equatable {
  public static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id
  }
}
