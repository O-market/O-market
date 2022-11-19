//
//  BadgeProductCell.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class BadgeProductCell: ProductCell {
  override class var cellContentViewType: ProductCellContentView.Type {
    return BadgeProductCellContentView.self
  }

  override func bind(viewModel: CellViewModelable) {
    super.bind(viewModel: viewModel)
    cellContentView.bind(viewModel: viewModel)
  }
}
