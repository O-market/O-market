//
//  ImageView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class ImageView: UIView {
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let removeButton = ODSXMarkButton()
  var removeAction: (() -> Void)?
  
  init(image: UIImage) {
    super.init(frame: .zero)
    configureUI()
    imageView.image = image
    removeButton.addTarget(
      self,
      action: #selector(removeButtonDidTap),
      for: .touchUpInside
    )
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
  private func removeButtonDidTap() {
    removeAction?()
    self.removeFromSuperview()
  }
}
