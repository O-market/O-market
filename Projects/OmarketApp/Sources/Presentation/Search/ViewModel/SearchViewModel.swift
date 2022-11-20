//
//  SearchViewModel.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol SearchViewModelInput {
  func searchTextDidChangeEvent(searchValue: String)
  func productDidTapEvent(product: Product)
}

protocol SearchViewModelOutput {
  var searchedProducts: Driver<[Product]> { get }
}

protocol SearchViewModelable: SearchViewModelInput, SearchViewModelOutput {}

final class SearchViewModel: SearchViewModelable {
  // MARK: Properties

  private let _searchedProducts = PublishRelay<[Product]>()
  var searchedProducts: Driver<[Product]> {
    return _searchedProducts.asDriver(onErrorJustReturn: [])
  }

  weak var coordinator: SearchCoordinator?
  private let useCase: ProductFetchUseCase
  private let disposeBag = DisposeBag()

  // MARK: Life Cycle

  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase
  }

  // MARK: Methods

  func searchTextDidChangeEvent(searchValue: String) {
    useCase.searchProducts(searchValue: searchValue)
      .catchAndReturn([])
      .bind(to: _searchedProducts)
      .disposed(by: disposeBag)
  }

  func productDidTapEvent(product: Product) {
    coordinator?.showDetailView(product.id)
  }

  // MARK: Helpers
}
