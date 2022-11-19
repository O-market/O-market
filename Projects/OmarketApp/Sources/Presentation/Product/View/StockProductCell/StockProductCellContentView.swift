//
//  StockProductCellContentView.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RGMagpie
import SnapKit

final class StockProductCellContentView: ProductCellContentView {
  // MARK: Interfaces

  private let productImageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()

  private let productNameLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_M16
    return label
  }()

  private lazy var costStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [bargainPriceLabel, priceLabel])
    view.axis = .vertical
    return view
  }()

  private lazy var bargainStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [discountPercentLabel, bargainPriceLabel])
    view.spacing = 4.0
    return view
  }()

  private let discountPercentLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R15
    label.textColor = .systemRed
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R13
    label.textColor = .systemGray
    return label
  }()

  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R15
    return label
  }()

  private lazy var stockStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [stockTitleLabel, stockLabel])
    view.axis = .vertical
    view.alignment = .trailing
    return view
  }()

  private let stockTitleLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R13
    return label
  }()

  private let stockLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R13
    return label
  }()

  // MARK: Properties

  // MARK: Life Cycle

  // MARK: Methods

  override func bind(viewModel: CellViewModelable) {
    super.bind(viewModel: viewModel)
    guard let viewModel = viewModel as? ProductCellViewModelable else { return }

    productImageView.mp.setImage(with: viewModel.imageURL)
    productNameLabel.text = viewModel.productName

    discountPercentLabel.text = viewModel.discountPercentage
    discountPercentLabel.isHidden = !viewModel.isSale

    priceLabel.strike()
    priceLabel.text = viewModel.price
    priceLabel.isHidden = !viewModel.isSale

    bargainPriceLabel.boldNumber()
    bargainPriceLabel.text = viewModel.bargainPrice

    stockLabel.boldNumber()
    stockLabel.text = viewModel.stock
    stockTitleLabel.text = viewModel.stockTitle
  }

  override func configureUI() {
    super.configureUI()
    backgroundColor = .systemBackground

    [productImageView, productNameLabel, costStackView, stockStackView].forEach {
      addSubview($0)
    }

    productImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(productImageView.snp.width).multipliedBy(1.2)
    }

    productNameLabel.snp.makeConstraints {
      $0.top.equalTo(productImageView.snp.bottom).offset(8.0)
      $0.leading.equalTo(productImageView).offset(4.0)
      $0.trailing.equalTo(productImageView).offset(-4.0)
    }

    costStackView.snp.makeConstraints {
      $0.top.equalTo(productNameLabel.snp.bottom).offset(8.0)
      $0.leading.equalTo(productImageView).offset(8.0)
    }

    stockStackView.snp.makeConstraints {
      $0.top.equalTo(costStackView)
      $0.trailing.equalTo(productImageView).offset(-8.0)
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

  func boldNumber() {
    guard let text = self.text,
          let number = text.components(separatedBy: " ").first else { return }

    let boldFont = UIFont.boldSystemFont(ofSize: self.font.pointSize)

    let range = (text as NSString).range(of: number)
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(.font, value: boldFont, range: range)
    self.attributedText = attributedString
  }
}
