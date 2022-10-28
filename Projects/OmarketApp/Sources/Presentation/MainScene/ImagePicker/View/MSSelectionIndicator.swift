//
//  MSSelectionIndicator.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class MSSelectionIndicator: UIView {
  var circleColor: UIColor = .systemIndigo
  
  let circle: UIView = {
    let view = UIView()
    return view
  }()
  
  let numberLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 11)
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    configureUI()
    setNumber(nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(circle)
    addSubview(numberLabel)
    let circleSize: CGFloat = 20
    circle.layer.cornerRadius = circleSize / 2.0
    circle.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(circleSize)
    }
    numberLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  func setNumber(_ number: Int?) {
    numberLabel.isHidden = (number == nil)
    if let number = number {
      circle.backgroundColor = circleColor
      circle.layer.borderColor = UIColor.clear.cgColor
      circle.layer.borderWidth = 0
      numberLabel.text = "\(number)"
    } else {
      circle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
      circle.layer.borderColor = UIColor.white.cgColor
      circle.layer.borderWidth = 1
      numberLabel.text = ""
    }
  }
}
