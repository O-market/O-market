//
//  TestCollectionViewController.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/27.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class TestCollectionViewController: UICollectionViewController {
  
  private var dataSource = Observable<[Product]>.of([
    Product(
      id: 1,
      vendorId: 2,
      name: "맥북프로",
      thumbnail: "없음",
      currency: "KRW",
      price: 9999,
      bargainPrice: 9000,
      discountedPrice: 999,
      stock: 10,
      createdAt: "2022-01-20T00:00:00.00",
      issuedAt: "2022-01-20T00:00:00.00"
    ),
    Product(
      id: 2,
      vendorId: 2,
      name: "맥북에어",
      thumbnail: "없음",
      currency: "USD",
      price: 999,
      bargainPrice: 999,
      discountedPrice: 0,
      stock: 10,
      createdAt: "2022-01-20T00:00:00.00",
      issuedAt: "2022-01-20T00:00:00.00")
  ])
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.backgroundColor = .systemGray5
    collectionView.dataSource = nil
    collectionView.delegate = nil
    
    collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
    
    self.dataSource
      .bind(to: collectionView.rx.items(
        cellIdentifier: ProductCell.identifier,
        cellType: ProductCell.self
      )) { _, item, cell in
        cell.bind(with: ProductCellViewModel(product: item))
      }
      .disposed(by: disposeBag)

    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension TestCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellWidth: CGFloat = 180
    let cellHeight: CGFloat = cellWidth * 25/16
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
