//
//  ProductCell.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RGMagpie
import SnapKit

final class ProductCell: UICollectionViewCell {
  // MARK: Interfaces

  private let productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let productNameLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_M16
    return label
  }()

  private let costStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()

  private let bargainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 4.0
    return stackView
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

  private let stockStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .trailing
    return stackView
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

  private var viewModel: ProductCellViewModelable?

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCell()
    addViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
    addViews()
    setupLayout()
  }

  // MARK: Methods

  func bind(viewModel: ProductCellViewModelable) {
    self.viewModel = viewModel

    self.productImageView.mp.setImage(with: viewModel.imageURL)
    self.productNameLabel.text = viewModel.productName

    self.discountPercentLabel.text = viewModel.dicountPercentage
    self.priceLabel.text = viewModel.price
    self.priceLabel.strike()
    
    self.bargainPriceLabel.text = viewModel.bargainPrice
    self.bargainPriceLabel.boldNumber()
    
    self.stockTitleLabel.text = viewModel.stockTitle
    self.stockLabel.text = viewModel.stock
    self.stockLabel.boldNumber()

    self.discountPercentLabel.isHidden = !viewModel.isSale
    self.priceLabel.isHidden = !viewModel.isSale
  }

  // MARK: Helpers

  private func addViews() {
    contentView.addSubview(productImageView)
    contentView.addSubview(productNameLabel)
    contentView.addSubview(costStackView)
    contentView.addSubview(stockStackView)
    
    costStackView.addArrangedSubview(bargainStackView)
    costStackView.addArrangedSubview(priceLabel)
    
    stockStackView.addArrangedSubview(stockTitleLabel)
    stockStackView.addArrangedSubview(stockLabel)
    
    bargainStackView.addArrangedSubview(discountPercentLabel)
    bargainStackView.addArrangedSubview(bargainPriceLabel)
  }
  
  private func setupCell() {
    self.backgroundColor = .systemBackground
  }
  
  private func setupLayout() {
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
