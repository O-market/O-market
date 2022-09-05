//
//  DetailViewModelItem+Extension.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

extension DetailViewModelItem: Equatable {
  public static func == (lhs: DetailViewModelItem, rhs: DetailViewModelItem) -> Bool {
    return lhs.title == rhs.title && lhs.thumbnail == rhs.thumbnail && lhs.body == rhs.body  }
}
