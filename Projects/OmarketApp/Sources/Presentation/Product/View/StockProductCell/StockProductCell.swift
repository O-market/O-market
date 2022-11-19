//
//  StockProductCell.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class StockProductCell: ProductCell {
  override class var cellContentViewType: ProductCellContentView.Type {
    return StockProductCellContentView.self
  }

  override func bind(viewModel: CellViewModelable) {
    super.bind(viewModel: viewModel)
    cellContentView.bind(viewModel: viewModel)
  }
}
