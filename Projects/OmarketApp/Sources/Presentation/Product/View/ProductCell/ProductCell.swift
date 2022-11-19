//
//  ProductCell.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

protocol CellViewModelable {}

class ProductCell: UICollectionViewCell {
  // MARK: Interfaces

  class var cellContentViewType: ProductCellContentView.Type { ProductCellContentView.self }
  private(set) var cellContentView: ProductCellContentView

  // MARK: Properties

  // MARK: Life Cycle

  override init(frame: CGRect) {
    cellContentView = Self.cellContentViewType.init()
    super.init(frame: frame)
    configureContentView()
  }

  required init?(coder: NSCoder) {
    cellContentView = Self.cellContentViewType.init()
    super.init(coder: coder)
    configureContentView()
  }

  // MARK: Methods

  func bind(viewModel: CellViewModelable) {
    // Bind ViewModel
  }

  // MARK: Helpers

  private func configureContentView() {
    contentView.addSubview(cellContentView)
    cellContentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
