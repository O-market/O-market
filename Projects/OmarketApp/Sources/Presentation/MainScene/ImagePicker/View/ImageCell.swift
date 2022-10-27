//
//  ImageCell.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/25.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

final class SelectionIndicator: UIView {
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

final class ImageCell: UICollectionViewCell {
  var representedAssetIdentifier: String!
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let selectionIndicator = SelectionIndicator()
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    addSubview(selectionIndicator)
    selectionIndicator.snp.makeConstraints {
      $0.top.equalToSuperview().offset(15)
      $0.right.equalToSuperview().offset(-15)
      
    }
  }
}
