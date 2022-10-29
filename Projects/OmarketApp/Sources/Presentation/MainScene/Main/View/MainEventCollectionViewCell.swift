//
//  MainEventCollectionViewCell.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RGMagpie

final class MainEventCollectionViewCell: UICollectionViewCell {
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(with cellItem: ProductSectionItemType) {
    guard let cellItem = cellItem as? ProductEvent else { return }

    imageView.image = UIImage(named: cellItem.name)
  }
}

// MARK: - UI

extension MainEventCollectionViewCell {
  private func configureUI() {
    contentView.addSubview(imageView)

    imageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }
}
