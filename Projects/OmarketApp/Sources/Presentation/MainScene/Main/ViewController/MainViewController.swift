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

final class MainViewController: UIViewController {
  typealias MainDataSource = RxCollectionViewSectionedReloadDataSource<ProductSection>

  private let menuSegmentControl: UIView = {
    let view = UIView()
    view.backgroundColor = .cyan
    return view
  }()
  private lazy var collectionView: UICollectionView = {
    let layout = configureCompositionalLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(
      MainProductCollectionViewHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MainProductCollectionViewHeader.identifier
    )
    return collectionView
  }()

  private let disposeBag = DisposeBag()
  private let viewModel: MainViewModelable

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
    bindUI()
  }

  private func bindUI() {
    let dataSource = configureCollectionViewDataSource()

    viewModel.sections
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  private func configureCollectionViewDataSource() -> MainDataSource {
    let dataSource = MainDataSource { dataSource, collectionView, indexPath, product in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
      cell.backgroundColor = [.red, .blue, .green].randomElement()
      return cell
    }

    dataSource.configureSupplementaryView = { [weak self] dataSource, collectionView, kind, indexPath in
      guard let self = self else { return UICollectionReusableView() }
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainProductCollectionViewHeader.identifier, for: indexPath) as? MainProductCollectionViewHeader else {
        return UICollectionReusableView()
      }
      header.bind(viewModel: self.viewModel)

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
    return section
  }

  private func configureProductSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)), subitem: item, count: 2)

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
    section.orthogonalScrollingBehavior = .groupPaging
    section.boundarySupplementaryItems = [header]

    return section
  }

  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(menuSegmentControl)
    view.addSubview(collectionView)

    menuSegmentControl.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(48.0)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(menuSegmentControl.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
