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
    return scrollView
  }()
  
  private let backgroundView = UIView()
  
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  let photoButton = ODSPhotoButtonView()
  
  private let buttonbackgarundView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var imageStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [buttonbackgarundView])
    stackView.spacing = 8
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  let titleTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .all)
    textField.placeholder = "상품명"
    return textField
  }()
  
  let priceTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "₩ 상품가격"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  let discountPriceTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "₩ 할인가격 (선택사항)"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  let stockTextField: ODSLineTextField = {
    let textField = ODSLineTextField(lineStyle: .bottom)
    textField.placeholder = "재고 수량"
    textField.keyboardType = .numberPad
    return textField
  }()
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.isScrollEnabled = false
    textView.showsVerticalScrollIndicator = false
    textView.font = ODS.Font.B_R15
    return textView
  }()
  
  let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R15
    label.textColor = .systemGray3
    label.text = "상품에 대한 설명을 입력해주세요."
    return label
  }()
  
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
    stackView.spacing = 16
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
    scrollView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    scrollView.addSubview(backgroundView)
    backgroundView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    backgroundView.addSubviews(
      [
        imageScrollView,
        textFieldStackView
      ]
    )

    imageScrollView.snp.makeConstraints {
      $0.trailing.leading.top.equalToSuperview().inset(8)
      $0.bottom.equalTo(textFieldStackView.snp.top).inset(-32)
      $0.height.equalTo(self).multipliedBy(0.18)
    }

    imageScrollView.addSubview(imageStackView)
    imageStackView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
      $0.height.equalToSuperview()
    }
    
    buttonbackgarundView.snp.makeConstraints {
      $0.width.equalTo(buttonbackgarundView.snp.height)
      $0.height.equalToSuperview()
    }
    
    buttonbackgarundView.addSubview(photoButton)
    photoButton.snp.makeConstraints {
      $0.width.equalTo(photoButton.snp.height)
      $0.height.equalToSuperview().multipliedBy(0.5)
      $0.center.equalToSuperview()
    }

    textFieldStackView.snp.makeConstraints {
      $0.top.equalTo(imageScrollView.snp.bottom)
      $0.bottom.equalToSuperview()
      $0.trailing.leading.equalToSuperview().inset(16)
      $0.width.equalToSuperview().inset(16)
    }
    textView.addSubview(placeholderLabel)
    placeholderLabel.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview().inset(7)
    }
  }
  
  func addImageView(_ views: [UIView]) {
    views.forEach {
      imageStackView.addArrangedSubview($0)
    }
  }
}
