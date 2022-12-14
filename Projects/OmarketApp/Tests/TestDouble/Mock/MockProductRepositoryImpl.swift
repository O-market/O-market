//
//  MockProductRepositoryImpl.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

import RxSwift

final class MockProductRepositoryImpl: ProductRepository {
  var fetchAllProductCallCount: Int = 0
  var fetchProductCallCount: Int = 0
  var createProductCallCount: Int = 0
  var updateProductCallCount: Int = 0
  var productURLCallCount: Int = 0
  var deleteProductCallCount: Int = 0

  func fetchAllProduct(endpoint: Endpoint) -> Observable<[Product]> {
    fetchAllProductCallCount += 1
    return .empty()
  }

  func fetchProduct(endpoint: Endpoint) -> Observable<Product> {
    fetchProductCallCount += 1
    return .empty()
  }
  
  func createProduct(endpoint: Endpoint) -> Observable<Void> {
    createProductCallCount += 1
    return .empty()
  }
  
  func updateProduct(endpoint: Endpoint) -> Observable<Void> {
    updateProductCallCount += 1
    return .empty()
  }
  
  func productURL(endpoint: OmarketApp.Endpoint) -> Observable<String> {
    productURLCallCount += 1
    return .empty()
  }
  
  func deleteProduct(endpoint: OmarketApp.Endpoint) -> Observable<Void> {
    deleteProductCallCount += 1
    return .empty()
  }
}
