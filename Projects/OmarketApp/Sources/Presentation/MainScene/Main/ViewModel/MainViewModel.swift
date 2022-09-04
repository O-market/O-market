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
  func showProductsButtonDidTapEvent()
}

protocol MainViewModelOutput {
  var title: String { get }
  var sections: Observable<[ProductSection]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
  // Input
  var title = "오픈 마켓"
  var sections: Observable<[ProductSection]> {
    return Observable.combineLatest(
      Observable.just(ProductEvent.items),
      useCase.fetchAll(query: .init(pageNumber: 1, itemsPerPage: 20))
    )
    .map { events, products in
      var sections = [ProductSection]()
      sections.append(ProductSection(sectionType: .event, items: events))
      sections.append(ProductSection(sectionType: .product, items: products))

      return sections
    }
  }

  weak var coordinator: MainCoordinator?
  private let disposeBag = DisposeBag()
  private let useCase: ProductFetchUseCase

  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase
  }

  // Output
  func showProductsButtonDidTapEvent() {
    coordinator?.showProductsScene()
  }
}
