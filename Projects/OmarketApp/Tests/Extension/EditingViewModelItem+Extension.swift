//
//  EditingViewModelItem+Extension.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/11/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import Foundation
@testable import OmarketApp

extension EditingViewModelItem: Equatable {
  public static func == (lhs: EditingViewModelItem, rhs: EditingViewModelItem) -> Bool {
    return lhs.title == rhs.title &&
    lhs.body == rhs.body &&
    lhs.price == rhs.price &&
    lhs.discountPrice == rhs.discountPrice &&
    lhs.stock == rhs.stock &&
    lhs.imageURL == rhs.imageURL
  }
}
