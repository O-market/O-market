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
  var productInfomation: Observable<Content> { get }
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModelImpl: DetailViewModel {
  let useCase: ProductFetchUseCase
  let productId: Int
  
  init(useCase: ProductFetchUseCase, productId: Int) {
    self.useCase = useCase
    self.productId = productId
  }
  
  var productInfomation: Observable<Content> {
    return useCase.fetchOne(id: productId)
      .map { Content(product: $0) }
  }
}

struct Content {
  let title: String
  let body: String?
  let thumbnail: String
  let price: String
  let bargainPrice: String
  let discountPercentage: String
  let stock: String
  
  init(product: Product) {
    self.title = product.name
    self.body = product.description
    self.thumbnail = product.thumbnail
    self.price = String(Int(product.price)) + " 원"
    self.bargainPrice = String(Int(product.bargainPrice))
    self.discountPercentage = String(Int(round(product.discountedPrice / product.price * 100))) + "%"
    self.stock = String(product.stock) + " 개"
  }
}
