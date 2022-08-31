//
//  DetailViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

protocol DetailViewModelInput {}

protocol DetailViewModelOutput {
  var productInfomation: Observable<DetailViewModelItem> { get }
  var productImageURL: Observable<[String]> { get }
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModelImpl: DetailViewModel {
  let useCase: ProductFetchUseCase
  let productId: Int
  
  init(useCase: ProductFetchUseCase, productId: Int) {
    self.useCase = useCase
    self.productId = productId
  }
  
  var productInfomation: Observable<DetailViewModelItem> {
    return useCase.fetchOne(id: productId)
      .map { DetailViewModelItem(product: $0) }
  }
  
  var productImageURL: Observable<[String]> {
    return useCase.fetchOne(id: productId)
      .compactMap { item in
        item.images?.compactMap { $0.url }
      }
  }
}
