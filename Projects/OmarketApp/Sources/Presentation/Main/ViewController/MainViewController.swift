//
//  MainViewController.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/01.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxDataSources
import RxCocoa
import RxSwift
import SnapKit

final class MainViewController: UIViewController {
  private typealias MainDataSource = RxCollectionViewSectionedReloadDataSource<ProductSection>

  // MARK: Interfaces

  private lazy var menuSegmentControl = ODSCategoryView(items: viewModel.categories)
  private lazy var collectionView: UICollectionView = {
    let layout = configureCompositionalLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = false

    collectionView.register(
      MainEventCell.self,
      forCellWithReuseIdentifier: MainEventCell.identifier
    )
    collectionView.register(
      StockProductCell.self,
      forCellWithReuseIdentifier: StockProductCell.identifier
    )
    collectionView.register(
      MainProductHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MainProductHeader.identifier
    )
    return collectionView
  }()

  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPage = 0
    pageControl.isUserInteractionEnabled = false
    return pageControl
  }()

  // MARK: Properties

  private let disposeBag = DisposeBag()
  private let viewModel: MainViewModelable

  // MARK: Life Cycle

  init(viewModel: MainViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind(viewModel: viewModel)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureNavigationBar()
  }

  // MARK: Methods

  // MARK: Helpers

  private func bind(viewModel: MainViewModelable) {
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
    let dataSource = MainDataSource { _, collectionView, indexPath, item in
      if indexPath.section == .zero {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MainEventCell.identifier,
          for: indexPath
        ) as? MainEventCell else { return UICollectionViewCell() }

        cell.bind(viewModel: MainEventCellViewModel(item: item))
        return cell

      } else {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: StockProductCell.identifier,
          for: indexPath
        ) as? StockProductCell else { return UICollectionViewCell() }

        guard let product = item as? Product else { return UICollectionViewCell() }

        cell.bind(viewModel: StockProductCellViewModel(product: product))
        return cell
      }
    }

    dataSource.configureSupplementaryView = { [weak self] _, collectionView, kind, indexPath in
      guard let self = self else { return UICollectionReusableView() }
      guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: MainProductHeader.identifier,
        for: indexPath
      ) as? MainProductHeader else { return UICollectionReusableView() }

      header.bind(viewModel: self.viewModel)
      return header
    }

    return dataSource
  }
}

// MARK: - UI

extension MainViewController {
  private func configureCompositionalLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, _ in
      if section == .zero {
        return self?.configureEventSection()

      } else {
        return self?.configureProductSection()
      }
    }
  }

  private func configureEventSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(0.5)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.visibleItemsInvalidationHandler = { [weak self] _, point, environment in
      let currentPointX = point.x
      let collectionViewWidth = environment.container.contentSize.width
      let currentPage = currentPointX / collectionViewWidth
      self?.pageControl.currentPage = Int(currentPage.rounded())
    }

    return section
  }

  private func configureProductSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.8),
      heightDimension: .fractionalHeight(0.4)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
    group.interItemSpacing = .fixed(8.0)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(60.0)
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

  private func configureNavigationBar() {
    navigationItem.title = viewModel.title
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
  }

  private func configureUI() {
    view.backgroundColor = ODS.Color.brand010
    view.addSubviews([menuSegmentControl, collectionView, pageControl])

    menuSegmentControl.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(48.0)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(menuSegmentControl.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    pageControl.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
