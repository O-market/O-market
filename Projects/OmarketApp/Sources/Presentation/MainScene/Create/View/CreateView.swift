//
//  CreateView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class CreateView: UIView {
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.bounces = false
    return scrollView
  }()
  
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.bounces = false
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let photoButton = ODSPhotoButtonView()
  
  private lazy var imageStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [photoButton])
    stackView.spacing = 8
    return stackView
  }()
  
  private let titleTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .all)
    textField.placeholder = "상품명"
    return textField
  }()
  
  private let priceTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "₩ 상품가격"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  private let discountPriceTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "₩ 할인가격 (선택사항)"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  private let stockTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "재고 수량"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  private let textView = UITextView()
  
  private lazy var textFieldStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        titleTextField,
        priceTextField,
        discountPriceTextField,
        stockTextField,
        textView
      ]
    )
    stackView.axis = .vertical
    return stackView
  }()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(scrollView)
    scrollView.addSubviews(
      [
        imageScrollView,
        textFieldStackView
      ]
    )
    imageScrollView.addSubview(imageStackView)
    
    scrollView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
    
    imageScrollView.snp.makeConstraints {
      $0.top.trailing.leading.equalToSuperview()
    }
    
    textFieldStackView.snp.makeConstraints {
      $0.top.equalTo(imageScrollView.snp.bottom)
      $0.trailing.leading.bottom.equalToSuperview()
    }
    
    imageStackView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }
}
