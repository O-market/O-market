//
//  ProductView.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxCocoa
import RxSwift
import SnapKit

final class ProductView: UIView {
  // MARK: Interfaces

  private let refreshControl = UIRefreshControl()

  private lazy var collectionView: UICollectionView = {
    let layout = makeCollectionViewLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.refreshControl = refreshControl
    return collectionView
  }()

  private lazy var addProductButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(ODS.Icon.plusCircleFill, for: .normal)
    button.tintColor = ODS.Color.brand010
    button.backgroundColor = .systemBackground
    button.clipsToBounds = true
    return button
  }()

  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: .zero)
    configureCollectionView()
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureCollectionView()
    configureUI()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    addProductButton.layer.cornerRadius = addProductButton.bounds.width * 0.5
  }

  // MARK: Methods

  func bind(viewModel: ProductViewModelable) {
    Observable.just(())
      .bind(onNext: viewModel.viewDidLoadEvent)
      .disposed(by: disposeBag)

    addProductButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(onNext: viewModel.addProductButtonDidTapEvent)
      .disposed(by: disposeBag)

    collectionView.rx.modelSelected(Product.self)
      .bind(onNext: viewModel.productDidTapEvent)
      .disposed(by: disposeBag)

    collectionView.rx.prefetchItems
      .compactMap { $0.first?.row }
      .bind(onNext: viewModel.prefetchIndexPathEvent)
      .disposed(by: disposeBag)

    refreshControl.rx.controlEvent(.valueChanged)
      .bind(onNext: viewModel.refreshProductsEvent)
      .disposed(by: disposeBag)

    viewModel.products
      .drive(collectionView.rx.items(
        cellIdentifier: BadgeProductCell.identifier,
        cellType: BadgeProductCell.self
      )) { _, product, cell in
        cell.bind(viewModel: ProductCellViewModel(product: product))
      }
      .disposed(by: disposeBag)

    viewModel.onRefreshed
      .drive(refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)
  }

  // MARK: Helpers

  private func configureUI() {
    self.backgroundColor = .systemBackground
    [collectionView, addProductButton].forEach { addSubview($0) }

    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
    
    addProductButton.snp.makeConstraints {
      $0.size.equalTo(50.0)
      $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-20.0)
    }
  }

  private func configureCollectionView() {
    collectionView.register(
      BadgeProductCell.self,
      forCellWithReuseIdentifier: BadgeProductCell.identifier
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
