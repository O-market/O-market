//
//  ProductViewModel.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol ProductViewModelInput {
  func productDidTapEvent(_ product: Product)
  func addProductButtonDidTapEvent()
  func prefetchIndexPathEvent(_ row: Int)
  func viewDidLoadEvent()
  func refreshProductsEvent()
}

protocol ProductViewModelOutput {
  var title: String { get }
  var products: Driver<[Product]> { get }
  var onRefreshed: Driver<Bool> { get }
}

protocol ProductViewModelable: ProductViewModelInput, ProductViewModelOutput { }

final class ProductViewModel: ProductViewModelable {
  private enum Constant {
    static let title = "전체보기"
  }

  // MARK: Properties

  weak var coordinator: ProductCoordinator?
  private let productFetchUseCase: ProductFetchUseCase
  private let disposeBag = DisposeBag()
  private var currentPage = 1

  let title = Constant.title

  private let _products = BehaviorRelay<[Product]>(value: [])
  var products: Driver<[Product]> {
    return _products.asDriver(onErrorJustReturn: [])
  }

  private let _onRefreshed = PublishRelay<Bool>()
  var onRefreshed: Driver<Bool> {
    return _onRefreshed.asDriver(onErrorJustReturn: false)
  }

  // MARK: Life Cycle

  init(useCase: ProductFetchUseCase) {
    self.productFetchUseCase = useCase

    NotificationCenter.default.rx.notification(.productsDidRenew)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.refreshProductsEvent()
      })
      .disposed(by: disposeBag)
  }

  // MARK: Methods

  func viewDidLoadEvent() {
    refreshProductsEvent()
  }

  func refreshProductsEvent() {
    productFetchUseCase.fetchAll(
      query: ProductRequestQuery(pageNumber: 1, itemsPerPage: 20)
    )
    .withUnretained(self)
    .bind(onNext: { owner, products in
      owner.currentPage = 1
      owner._products.accept(products)
      owner._onRefreshed.accept(false)
    })
    .disposed(by: disposeBag)
  }

  func productDidTapEvent(_ product: Product) {
    coordinator?.showDetailView(product.id)
  }

  func addProductButtonDidTapEvent() {
    coordinator?.showCreateView()
  }

  func prefetchIndexPathEvent(_ row: Int) {
    if row / 20 + 1 == currentPage {
      currentPage += 1
      appendProducts(pageNumber: currentPage, itemsPerPage: 20)
    }
  }

  // MARK: Helpers

  private func appendProducts(pageNumber: Int, itemsPerPage: Int) {
    productFetchUseCase.fetchAll(
      query: ProductRequestQuery(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
    )
    .withUnretained(self)
    .subscribe(onNext: { owner, products in
      owner._products.accept(owner._products.value + products)
    })
    .disposed(by: disposeBag)
  }
}
