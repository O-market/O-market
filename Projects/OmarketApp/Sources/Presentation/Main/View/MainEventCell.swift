//
//  MainEventCell.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RGMagpie
import SnapKit

final class MainEventCell: UICollectionViewCell {
  // MARK: Interfaces

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  // MARK: Properties

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }

  // MARK: Methods

  func bind(viewModel: MainEventCellViewModel) {
    guard let item = viewModel.item as? ProductEvent else { return }

    imageView.image = UIImage(named: item.name)
  }

  // MARK: Helpers

  private func configureUI() {
    contentView.addSubview(imageView)

    imageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }
}
