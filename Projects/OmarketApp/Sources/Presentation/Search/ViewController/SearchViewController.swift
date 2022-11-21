//
//  SearchViewController.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class SearchViewController: UIViewController {
  private enum Constant {
    static let navigationTitle = "검색"
  }

  // MARK: Interfaces

  private let searchView = SearchView()

  // MARK: Properties

  private let viewModel: SearchViewModelable

  // MARK: Life Cycle

  init(viewModel: SearchViewModelable) {
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

  private func bind(viewModel: SearchViewModelable) {
    searchView.bind(viewModel: viewModel)
  }

  private func configureNavigationBar() {
    navigationItem.title = Constant.navigationTitle
    navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
  }

  private func configureUI() {
    view.backgroundColor = ODS.Color.brand010
    view.addSubview(searchView)
    searchView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
