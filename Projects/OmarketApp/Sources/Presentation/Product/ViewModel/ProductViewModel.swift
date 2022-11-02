//
//  ProductViewModel.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import RxSwift
import RxRelay

protocol ProductViewModelInput {
  func didTapCell(_ product: Product)
  func didTapAddProductButton()
  func requestProducts(pageNumber: Int, itemsPerPage: Int)
  func prefetchIndexPath(_ row: Int)
}

protocol ProductViewModelOutput {
  var title: String { get }
  var products: BehaviorRelay<[Product]> { get }
  var showProductAddScene: PublishRelay<Void> { get }
  var showProductDetailScene: PublishRelay<Product> { get }
}

protocol ProductViewModelable: ProductViewModelInput, ProductViewModelOutput {}

final class ProductViewModel: ProductViewModelable {
  private let productFetchUseCase: ProductFetchUseCase
  private let disposeBag = DisposeBag()
  private var currentPage = 1
  
  init(useCase: ProductFetchUseCase) {
    self.productFetchUseCase = useCase
  }
  
  // MARK: Output
  
  let title = "전체 보기"
  let products = BehaviorRelay<[Product]>(value: [])
  let showProductAddScene = PublishRelay<Void>()
  let showProductDetailScene = PublishRelay<Product>()
}

extension ProductViewModel {
  // MARK: Input
  
  func didTapCell(_ product: Product) {
    showProductDetailScene.accept(product)
  }
  
  func didTapAddProductButton() {
    showProductAddScene.accept(())
  }
  
  func requestProducts(pageNumber: Int, itemsPerPage: Int) {
    productFetchUseCase.fetchAll(
      query: ProductRequestQuery(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
    )
    .subscribe(onNext: { [weak self] item in
      guard let self = self else { return }
      
      self.products.accept(self.products.value + item)
    })
    .disposed(by: disposeBag)
  }
  
  func prefetchIndexPath(_ row: Int) {
    if row / 20 + 1 == self.currentPage {
      self.currentPage += 1
      requestProducts(pageNumber: self.currentPage, itemsPerPage: 20)
    }
  }
}
