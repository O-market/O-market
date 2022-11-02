//
//  MSImageCell.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/25.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

final class MSImageCell: UICollectionViewCell {
  var representedAssetIdentifier: String!
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let selectionIndicator = MSSelectionIndicator()
  
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
