//
//  DetailView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

final class DetailView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19.1411, weight: .bold)
    return label
  }()
  
  private lazy var priceAndStockStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [priceStackView,
                                                   stockStackView])
    
    return stackView
  }()
  
  private lazy var priceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [bargainPriceStackView,
                                                   priceLabel])
    stackView.axis = .vertical
    
    return stackView
  }()
  
  private lazy var bargainPriceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [discountPercentageLabel,
                                                   discountedPriceStackView])
    stackView.spacing = 8
    return stackView
  }()
  
  private let discountPercentageLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19.1411, weight: .bold)
    label.textColor = .systemRed
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var discountedPriceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [discountedPriceLabel,
                                                   priceSignLabel])
    stackView.spacing = 4
    return stackView
  }()
  
  private let discountedPriceLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 19.1411, weight: .bold)
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private let priceSignLabel: UILabel = {
    let label = UILabel()
    label.text = "원"
    label.font = .systemFont(ofSize: 19.1411)

    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14.3558)
    label.textColor = .systemGray3
    return label
  }()
  
  private lazy var stockStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [stockGuideLabel,
                                                   stockLabel])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let stockGuideLabel: UILabel = {
    let label = UILabel()
    label.text = "잔여 수량"
    label.font = .systemFont(ofSize: 13)
    
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17, weight: .bold)
    label.textAlignment = .center
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var informationStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [informationGuideLabel,
                                                   informationLabel])
    stackView.axis = .vertical
    stackView.spacing = 24
    return stackView
  }()
  
  private let informationGuideLabel: UILabel = {
    let label = UILabel()
    label.text = "상품 상세 정보"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      configureUI()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.trailing.leading.top.equalToSuperview()
    }
    
    addSubview(priceAndStockStackView)
    
    priceAndStockStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).inset(-16)
      $0.leading.trailing.equalToSuperview().inset(8)
    }
    
    addSubview(informationStackView)
    
    informationStackView.snp.makeConstraints {
      $0.top.equalTo(priceAndStockStackView.snp.bottom).inset(-32)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}
