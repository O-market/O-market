//
//  ProductImageView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RGMagpie
import SnapKit

final class ProductImageView: UIView {
  var identifier: String?
  
  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
    }
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let removeButton = ODSXMarkButton()
  var removeAction: (() -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
    removeButton.addTarget(
      self,
      action: #selector(removeButtonDidTap),
      for: .touchUpInside
    )
  }
  
  convenience init(image: UIImage) {
    self.init()
    imageView.image = image
  }
  
  convenience init(imageURL: String) {
    self.init()
    imageView.mp.setImage(with: imageURL)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubviews(
      [
        imageView,
        removeButton
      ]
    )
    backgroundColor = .clear
    
    imageView.snp.makeConstraints {
      $0.top.right.equalToSuperview().inset(10)
      $0.bottom.left.equalToSuperview()
    }
    removeButton.snp.makeConstraints {
      $0.top.right.equalToSuperview()
    }
  }
  
  @objc
  func removeButtonDidTap() {
    removeAction?()
    self.removeFromSuperview()
  }
}
