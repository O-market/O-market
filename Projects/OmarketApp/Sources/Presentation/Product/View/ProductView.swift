//
//  ProductView.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class ProductView: UIView {
  // MARK: Interfaces

  let addProductButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
    button.tintColor = ODS.Color.brand010
    button.backgroundColor = .systemBackground
    button.clipsToBounds = true
    return button
  }()

  private(set) lazy var productsCollectionView: UICollectionView = {
    let layout = makeCollectionViewLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  // MARK: Properties

  // MARK: Life Cycle

  init() {
    super.init(frame: .zero)
    addViews()
    setupLayout()
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addViews()
    setupLayout()
    setupView()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    addProductButton.layer.cornerRadius = addProductButton.frame.width * 0.5
  }

  // MARK: Methods

  // MARK: Helpers

  private func addViews() {
    self.addSubview(productsCollectionView)
    self.addSubview(addProductButton)
  }
  
  private func setupLayout() {
    productsCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addProductButton.snp.makeConstraints {
      $0.width.height.equalTo(50.0)
      $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-20.0)
    }
  }
  
  private func setupView() {
    self.backgroundColor = .systemBackground
    productsCollectionView.register(
      StockProductCell.self,
      forCellWithReuseIdentifier: StockProductCell.identifier
    )
  }

  private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, environment in
      let itemWidth = (environment.container.effectiveContentSize.width - 40.0) * 0.5
      let itemHeight = itemWidth * 1.5

      let itemSize = NSCollectionLayoutSize(
        widthDimension: .absolute(itemWidth),
        heightDimension: .absolute(itemHeight)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(itemHeight)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(8.0)

      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 48.0
      section.contentInsets = .init(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)

      return section
    }
  }
}
