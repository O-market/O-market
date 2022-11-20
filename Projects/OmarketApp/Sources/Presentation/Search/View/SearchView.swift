//
//  SearchView.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SearchView: UIView {
  // MARK: Interfaces

  private let searchBar = UISearchBar()
  private let tableView = UITableView()

  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureTableView()
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureTableView()
    configureUI()
  }

  // MARK: Methods

  func bind(viewModel: SearchViewModelable) {
    searchBar.rx.text
      .orEmpty
      .filter { !$0.isEmpty }
      .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
      .bind(onNext: viewModel.searchTextDidChangeEvent)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .bind(onNext: { [weak self] in
        self?.tableView.deselectRow(at: $0, animated: true)
      })
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(Product.self)
      .bind(onNext: viewModel.productDidTapEvent)
      .disposed(by: disposeBag)

    viewModel.searchedProducts
      .drive(tableView.rx.items(
        cellIdentifier: SearchCell.identifier,
        cellType: SearchCell.self
      )) { _, product, cell in
        cell.bind(viewModel: SearchCellViewModel(product: product))
      }
      .disposed(by: disposeBag)
  }

  // MARK: Helpers

  private func configureUI() {
    backgroundColor = .systemBackground
    [searchBar, tableView].forEach { addSubview($0) }

    searchBar.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func configureTableView() {
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
  }
}
