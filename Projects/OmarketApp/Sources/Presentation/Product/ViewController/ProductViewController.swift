//
//  ProductViewController.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

class ProductViewController: UIViewController {
  // MARK: Interfaces

  private lazy var productView = ProductView()

  // MARK: Properties

  private let viewModel: ProductViewModelable

  // MARK: Life Cycle

  init(viewModel: ProductViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    bind(viewModel: viewModel)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureNavigationBar()
  }

  // MARK: Methods

  // MARK: Helpers

  private func configureNavigationBar() {
    navigationItem.title = viewModel.title
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: nil)
    navigationController?.navigationBar.titleTextAttributes = nil
  }
  
  private func bind(viewModel: ProductViewModelable) {
    productView.bind(viewModel: viewModel)
  }

  private func configureUI() {
    view.backgroundColor = .systemBackground

    view.addSubview(productView)
    productView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
