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
  var products: [Product]
  var imageDatas = [Data]()
  
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
    products.append(product)
    imageDatas += images
    return .just(Void())
  }
  
  func updateProduct(product: Product) -> Observable<Void> {
    products.append(product)
    return .just(Void())
  }
  
  func searchProducts(searchValue: String) -> Observable<[Product]> {
    return .just(products)
  }
  
  func productURL(id: Int, password: String) -> Observable<String> {
    return .just("url")
  }
  
  func deleteProduct(url: String) -> Observable<Void> {
    return .just(Void())
  }
}
