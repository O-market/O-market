//
//  ProductRepositoryImpl.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

final class ProductRepositoryImpl: ProductRepository {
  private let networkService: NetworkService
  private let decoder = JSONDecoder()

  init(networkService: NetworkService) {
    self.networkService = networkService
  }

  func fetchAllProduct(query: ProductRequestQuery) -> Observable<[Product]> {
    let endpoint = EndpointAPI.products(query).asEndpoint
    return networkService.request(endpoint: endpoint)
      .decode(type: ProductResponseDTO.self, decoder: decoder)
      .map { $0.products }
      .map { $0.map { $0.toDomain() } }
  }

  func fetchProduct(id: Int) -> Observable<Product> {
    let endpoint = EndpointAPI.product(id).asEndpoint
    return networkService.request(endpoint: endpoint)
      .decode(type: ProductDTO.self, decoder: decoder)
      .map { $0.toDomain() }
  }
}
