//
//  MainEventCollectionViewCell.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import Magpie

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

  func bind() {
    imageView.mp.setImage(with: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/005bd2af79b211ec9173fda99364e03a.png")
  }
}

// MARK: - UI

extension MainEventCollectionViewCell {
  private func configureUI() {
    contentView.addSubview(imageView)

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
