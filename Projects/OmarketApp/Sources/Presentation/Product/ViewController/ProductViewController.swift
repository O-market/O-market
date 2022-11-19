//
//  ProductViewController.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ProductViewController: UIViewController {
  // MARK: Interfaces

  // MARK: Properties

  weak var coordinator: ProductCoordinator?
  private let viewModel: ProductViewModelable
  private let disposeBag = DisposeBag()

  // MARK: Life Cycle

  init(viewModel: ProductViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    view = ProductView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    bind(viewModel: viewModel)
    viewModel.requestProducts(pageNumber: 1, itemsPerPage: 20)
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
    guard let view = view as? ProductView else { return }

    view.addProductButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.didTapAddProductButton()
      }
      .disposed(by: disposeBag)
    
    view.productsCollectionView.rx.modelSelected(Product.self)
      .bind { [weak self] item in
        self?.viewModel.didTapCell(item)
      }
      .disposed(by: disposeBag)
    
    view.productsCollectionView.rx.prefetchItems
      .bind { [weak self] indexPath in
        guard let nextRow = indexPath.first?.row else { return }
        self?.viewModel.prefetchIndexPath(nextRow)
      }
      .disposed(by: disposeBag)
    
    viewModel.products
      .bind(to: view.productsCollectionView.rx.items(
        cellIdentifier: StockProductCell.identifier,
        cellType: StockProductCell.self
      )) { _, item, cell in
        cell.bind(viewModel: StockProductCellViewModel(product: item))
    }
    .disposed(by: disposeBag)
    
    viewModel.showProductAddScene
      .bind { [weak self] in
        self?.coordinator?.showCreateView()
      }
      .disposed(by: disposeBag)
    
    viewModel.showProductDetailScene
      .bind { [weak self] product in
        self?.coordinator?.showDetailView(product.id)
      }
      .disposed(by: disposeBag)
  }
}
