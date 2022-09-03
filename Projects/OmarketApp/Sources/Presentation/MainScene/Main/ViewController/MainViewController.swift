//
//  MainViewController.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/01.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import ODesignSystem

final class MainViewController: UIViewController {
  typealias MainDataSource = RxCollectionViewSectionedReloadDataSource<ProductSection>

  private let menuSegmentControl = MenuSegmentControl()
  private lazy var collectionView: UICollectionView = {
    let layout = configureCompositionalLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = false
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(
      MainEventCollectionViewCell.self,
      forCellWithReuseIdentifier: MainEventCollectionViewCell.identifier
    )
    collectionView.register(
      ProductCell.self,
      forCellWithReuseIdentifier: ProductCell.identifier
    )
    collectionView.register(
      MainProductCollectionViewHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MainProductCollectionViewHeader.identifier
    )

    return collectionView
  }()
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPage = 0
    pageControl.isUserInteractionEnabled = false
    return pageControl
  }()

  private let disposeBag = DisposeBag()
  private let viewModel: MainViewModelable

  init(viewModel: MainViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "오픈 마켓"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindUI()
    viewModel.viewDidLoadEvent()
  }

  private func bindUI() {
    let dataSource = configureCollectionViewDataSource()

    viewModel.sections
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    viewModel.sections
      .compactMap { $0.first }
      .map { $0.items.count }
      .bind(to: pageControl.rx.numberOfPages)
      .disposed(by: disposeBag)
  }

  private func configureCollectionViewDataSource() -> MainDataSource {
    let dataSource = MainDataSource { dataSource, collectionView, indexPath, product in
      if indexPath.section == .zero {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainEventCollectionViewCell.identifier, for: indexPath) as? MainEventCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.bind(with: product)

        return cell

      } else {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ProductCell.identifier,
          for: indexPath
        ) as? ProductCell else {
          return UICollectionViewCell()
        }
        cell.bind(with: ProductCellViewModel(product: product as! Product))

        return cell
      }
    }

    dataSource.configureSupplementaryView = { [weak self] dataSource, collectionView, kind, indexPath in
      guard let self = self else { return UICollectionReusableView() }
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainProductCollectionViewHeader.identifier, for: indexPath) as? MainProductCollectionViewHeader else {
        return UICollectionReusableView()
      }
      header.bind(with: self.viewModel)

      return header
    }

    return dataSource
  }
}

// MARK: - UI

extension MainViewController {
  private func configureCompositionalLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, environment in
      if section == .zero {
        return self?.configureEventSection()
      } else {
        return self?.configureProductSection()
      }
    }
  }

  private func configureEventSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging

    section.visibleItemsInvalidationHandler = { [weak self] _, point, environment in
      let currentPointX = point.x
      let collectionViewWidth = environment.container.contentSize.width
      let currentPage = currentPointX / collectionViewWidth
      self?.pageControl.currentPage = Int(currentPage)
    }

    return section
  }

  private func configureProductSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.4)), subitem: item, count: 2)
    group.interItemSpacing = .fixed(8.0)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(48.0)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.boundarySupplementaryItems = [header]
    section.interGroupSpacing = 8.0
    section.contentInsets = .init(top: 0, leading: 16.0, bottom: 0, trailing: 0)

    return section
  }

  private func configureUI() {
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]

    view.backgroundColor = ODS.Color.brand010
    view.addSubview(menuSegmentControl)
    view.addSubview(collectionView)
    view.addSubview(pageControl)

    menuSegmentControl.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(48.0)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(menuSegmentControl.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    pageControl.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
}
