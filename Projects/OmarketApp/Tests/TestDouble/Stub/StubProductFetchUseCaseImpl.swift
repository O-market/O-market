//
//  StubProductFetchUseCaseImpl.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

import RxSwift
final class StubProductFetchUseCaseImpl: ProductFetchUseCase {
  let products: [Product]
  
  init(products: [Product]){
    self.products = products
  }
  
  func fetchAll(query: ProductRequestQuery) -> Observable<[Product]> {
    return .just(products)
  }
  
  func fetchOne(id: Int) -> Observable<Product> {
    return .just(products.first!)
  }
  
  func createProduct(product: Product, images: [Data]) -> Observable<Void> {
    return .just(Void())
  }
}
