//
//  ProductFetchUseCase.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

struct ProductRequestQuery {
  let pageNumber: Int
  let itemsPerPage: Int
}

protocol ProductFetchUseCase {
  func fetchAll(query: ProductRequestQuery) -> Observable<[Product]>
  func fetchOne(id: Int) -> Observable<Product>
}

final class ProductFetchUseCaseImpl: ProductFetchUseCase {
  private let repository: ProductRepository

  init(repository: ProductRepository) {
    self.repository = repository
  }

  func fetchAll(query: ProductRequestQuery) -> Observable<[Product]> {
    let endpoint = EndpointAPI.products(query).asEndpoint
    return repository.fetchAllProduct(endpoint: endpoint)
  }

  func fetchOne(id: Int) -> Observable<Product> {
    let endpoint = EndpointAPI.product(id).asEndpoint
    return repository.fetchProduct(endpoint: endpoint)
  }
}
