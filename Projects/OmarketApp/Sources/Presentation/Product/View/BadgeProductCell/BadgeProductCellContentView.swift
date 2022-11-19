//
//  BadgeProductCellContentView.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RGMagpie
import SnapKit

final class BadgeProductCellContentView: ProductCellContentView {
  // MARK: Interfaces

  private lazy var productImageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()

  private let productNameLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R15
    return label
  }()

  private lazy var productPriceView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [discountPercentLabel, bargainPriceLabel])
    view.axis = .horizontal
    view.spacing = 4.0
    view.distribution = .fill
    view.alignment = .leading
    return view
  }()

  private let discountPercentLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_B13
    label.textColor = .systemRed
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    return label
  }()

  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_B13
    return label
  }()

  private let originPriceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R11
    label.textColor = .systemGray
    return label
  }()

  private let stockBadgeView: UIView = {
    let view = UIView()
    view.backgroundColor = ODS.Color.brand010.withAlphaComponent(0.8)
    return view
  }()

  private let stockBadgeLabel: UILabel = {
    let label = UILabel()
    label.text = "품절"
    label.font = ODS.Font.B_B13
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()

  // MARK: Properties

  // MARK: Life Cycle

  // MARK: Methods

  override func bind(viewModel: ProductCellViewModelable) {
    super.bind(viewModel: viewModel)
    guard let viewModel = viewModel as? StockProductCellViewModel else { return }

    productImageView.mp.setImage(with: viewModel.imageURL)
    productNameLabel.text = viewModel.productName

    discountPercentLabel.text = viewModel.discountPercentage
    discountPercentLabel.isHidden = !viewModel.isSale
    bargainPriceLabel.text = viewModel.bargainPrice

    originPriceLabel.strike()
    originPriceLabel.text = viewModel.price
    originPriceLabel.isHidden = !viewModel.isSale

    stockBadgeView.isHidden = !viewModel.isSoldout
  }

  override func configureUI() {
    super.configureUI()

    backgroundColor = .systemBackground

    stockBadgeView.addSubview(stockBadgeLabel)
    [productImageView, stockBadgeView, productNameLabel, productPriceView, originPriceLabel].forEach {
      addSubview($0)
    }

    productImageView.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
      $0.height.equalTo(productImageView.snp.width).multipliedBy(1.2)
    }

    stockBadgeLabel.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    stockBadgeView.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.3)
      $0.height.equalTo(30.0)
    }

    productNameLabel.snp.makeConstraints {
      $0.top.equalTo(productImageView.snp.bottom).offset(8.0)
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }

    productPriceView.snp.makeConstraints {
      $0.top.equalTo(productNameLabel.snp.bottom).offset(8.0)
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }

    originPriceLabel.snp.makeConstraints {
      $0.top.equalTo(productPriceView.snp.bottom).offset(4.0)
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }
  }

  // MARK: Helpers
}

// MARK: Extensions

private extension UILabel {
  func strike() {
    guard let text = self.text else { return }

    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSRange(location: 0, length: attributedString.length)
    )
    self.attributedText = attributedString
  }
}
