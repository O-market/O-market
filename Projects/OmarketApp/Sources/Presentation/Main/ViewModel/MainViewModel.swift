//
//  MainViewModel.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol MainViewModelInput {
  func viewDidLoadEvent()
  func showProductsButtonDidTapEvent()
}

protocol MainViewModelOutput {
  var title: String { get }
  var categories: [String] { get }
  var sections: Driver<[ProductSection]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput { }

final class MainViewModel: MainViewModelable {
  private enum Constant {
    static let title = "오픈마켓"
    static let categories = ["오픈마켓", "신상품"]
  }

  // MARK: Properties

  let title = Constant.title
  let categories = Constant.categories

  private let _events = Observable.just(ProductEvent.items)
  private let _products = PublishRelay<[Product]>()

  var sections: Driver<[ProductSection]> {
    return Observable.combineLatest(_events, _products)
    .map { events, products in
      var sections = [ProductSection]()
      sections.append(ProductSection(sectionType: .event, items: events))
      sections.append(ProductSection(sectionType: .product, items: products))
      return sections
    }
    .asDriver(onErrorJustReturn: [])
  }

  weak var coordinator: MainCoordinator?
  private let disposeBag = DisposeBag()
  private let useCase: ProductFetchUseCase

  // MARK: Life Cycle

  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase

    NotificationCenter.default.rx.notification(.productsDidRenew)
      .withUnretained(self)
      .flatMap { _ in useCase.fetchAll(query: .init(pageNumber: 1, itemsPerPage: 20)) }
      .bind(to: _products)
      .disposed(by: disposeBag)
  }

  // MARK: Methods

  func viewDidLoadEvent() {
    useCase.fetchAll(query: .init(pageNumber: 1, itemsPerPage: 20))
      .bind(to: _products)
      .disposed(by: disposeBag)
  }

  func showProductsButtonDidTapEvent() {
    coordinator?.showProductsScene()
  }

  // MARK: Helpers
}
