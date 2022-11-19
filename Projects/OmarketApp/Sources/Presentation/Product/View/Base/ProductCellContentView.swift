//
//  ProductCellContentView.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

class ProductCellContentView: UIView {
  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }

  // MARK: Methods

  func bind(viewModel: ProductCellViewModelable) {}
  func configureUI() {}
}
