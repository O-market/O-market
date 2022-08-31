//
//  ProductImageCell.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/31.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import Magpie
import SnapKit

final class ProductImageCell: UICollectionViewCell {
  let imageView: UIImageView = .init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setImage(imageURL: String) {
    imageView.mp.setImage(with: imageURL)
  }
  
  private func configureUI() {
    addSubview(imageView)
    
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
