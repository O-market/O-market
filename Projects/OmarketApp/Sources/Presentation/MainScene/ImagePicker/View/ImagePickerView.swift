//
//  ImagePickerView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/25.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

final class ImagePickerView: UIView {
  let navigationBar = UINavigationBar()
  let navigationitem = UINavigationItem(title: "사진첩")
  let addButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem(title: "0 add")
    barButton.setTitleTextAttributes(
      [.font : UIFont.boldSystemFont(ofSize: 18)],
      for: .normal
    )
    barButton.isEnabled = false
    return barButton
  }()
  let cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )
  
  private(set) lazy var photoCollectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: collectionViewLayout
    )
    return collectionView
  }()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    navigationitem.rightBarButtonItems = [addButton]
    navigationitem.leftBarButtonItems = [cancelButton]
    navigationBar.items = [navigationitem]
    
    addSubview(navigationBar)
    addSubview(photoCollectionView)
    navigationBar.snp.makeConstraints {
      $0.top.trailing.leading.equalToSuperview()
      $0.bottom.equalTo(photoCollectionView.snp.top)
    }
    photoCollectionView.snp.makeConstraints {
      $0.bottom.trailing.leading.equalTo(self.safeAreaLayoutGuide)
    }
    photoCollectionView.register(
      ImageCell.self,
      forCellWithReuseIdentifier: ImageCell.identifier
    )
  }
  
  private var collectionViewLayout: UICollectionViewCompositionalLayout {
    let fraction: CGFloat = 1 / 3
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(fraction),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(fraction)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func setSelectionCount(_ number: Int) {
    addButton.title = "\(number) add"
  }
}
