//
//  ProductsViewController.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ProductsViewController: UIViewController {
  
  private let viewModel: ProductsViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: ProductsCoordinator?
  
  init(_ viewModel: ProductsViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    view = ProductsView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
    viewModel.requestProducts(pageNumber: 1, itemsPerPage: 20)
  }
  
  private func bind() {
    guard let view = view as? ProductsView else { return }
    
    self.title = viewModel.title
    
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
      .bind(
        to: view.productsCollectionView.rx.items(
        cellIdentifier: ProductCell.identifier,
        cellType: ProductCell.self
      )) { index, item, cell in
        cell.bind(with: ProductCellViewModel(product: item))
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
