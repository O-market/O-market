//
//  ProductsView.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class ProductsView: UIView {
  
  let addProductButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
    button.tintColor = ODS.Color.brand010
    button.backgroundColor = .systemBackground
    button.clipsToBounds = true
    
    return button
  }()
  
  private(set) lazy var productsCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    
    return collectionView
  }()
  
  init() {
    super.init(frame: .zero)
    addViews()
    setupLayout()
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    addProductButton.layer.cornerRadius = addProductButton.frame.width / 2
  }
  
  private func addViews() {
    self.addSubview(productsCollectionView)
    self.addSubview(addProductButton)
  }
  
  private func setupLayout() {
    productsCollectionView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }
    
    addProductButton.snp.makeConstraints {
      $0.width.height.equalTo(50)
      $0.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
    }
  }
  
  private func setupView() {
    self.backgroundColor = .systemBackground
    productsCollectionView.register(
      ProductCell.self,
      forCellWithReuseIdentifier: ProductCell.identifier
    )
  }
  
  private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, environment in
      let itemWidth = environment.container.effectiveContentSize.width / 2
      let itemHeight = itemWidth * 7 / 5
    
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .absolute(itemWidth),
        heightDimension: .absolute(itemHeight)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
      
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(itemHeight)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      return NSCollectionLayoutSection(group: group)
    }
  }
}
