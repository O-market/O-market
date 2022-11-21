//
//  SearchCell.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class SearchCell: UITableViewCell {
  static let identifier = "SearchCell"

  // MARK: Interfaces

  private let productNameLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R15
    return label
  }()

  // MARK: Properties

  // MARK: Life Cycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }

  // MARK: Methods

  func bind(viewModel: SearchCellViewModelable) {
    productNameLabel.text = viewModel.product.name
  }

  // MARK: Helpers

  private func configureUI() {
    addSubview(productNameLabel)
    productNameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.top.equalToSuperview().offset(8.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
}
