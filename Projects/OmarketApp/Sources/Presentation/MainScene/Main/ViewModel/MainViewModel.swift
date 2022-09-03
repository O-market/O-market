//
//  MainViewModel.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

protocol MainViewModelInput {
  func viewDidLoadEvent()
  func showProductsButtonDidTapEvent()
}

protocol MainViewModelOutput {
  var sections: Observable<[ProductSection]> { get }
}

protocol MainViewModelable: MainViewModelInput & MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
  var sections: Observable<[ProductSection]> {
    let eventObservable = Observable<[String]>.just(["event01", "event02", "event03", "event04"])
      .map { $0.map { ProductEvent(name: $0) } }

    return Observable.combineLatest(
      eventObservable,
      products
    )
    .map { events, products in
      var sections = [ProductSection]()
      sections.append(ProductSection(sectionType: .event, items: events))
      sections.append(ProductSection(sectionType: .product, items: products))

      return sections
    }
  }
  private let products = BehaviorRelay<[Product]>(value: [])

  weak var coordinator: MainCoordinator?
  private let disposeBag = DisposeBag()
  private let useCase: ProductFetchUseCase

  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase
  }

  func viewDidLoadEvent() {
    useCase.fetchAll(query: .init(pageNumber: 1, itemsPerPage: 10))
      .withUnretained(self)
      .bind(onNext: { owner, products in
        owner.products.accept(products)
      })
      .disposed(by: disposeBag)
  }

  func showProductsButtonDidTapEvent() {
    coordinator?.showProductsScene()
  }
}
