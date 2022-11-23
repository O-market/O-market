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

  func fetchAllProduct(endpoint: Endpoint) -> Observable<[Product]> {
    return networkService.request(endpoint: endpoint)
      .decode(type: ProductResponseDTO.self, decoder: decoder)
      .map { $0.products }
      .map { $0.map { $0.toDomain() } }
  }

  func fetchProduct(endpoint: Endpoint) -> Observable<Product> {
    return networkService.request(endpoint: endpoint)
      .decode(type: ProductDTO.self, decoder: decoder)
      .map { $0.toDomain() }
  }
  
  func createProduct(endpoint: Endpoint) -> Observable<Void> {
    return networkService.request(endpoint: endpoint)
      .map { _ in }
  }
  
  func updateProduct(endpoint: Endpoint) -> Observable<Void> {
    return networkService.request(endpoint: endpoint)
      .map { _ in }
  }
  
  func productURL(endpoint: Endpoint) -> Observable<String> {
    return networkService.request(endpoint: endpoint)
      .map { String(data: $0, encoding: .utf8) ?? "" }
  }
  
  func deleteProduct(endpoint: Endpoint) -> Observable<Void> {
    return networkService.request(endpoint: endpoint)
      .map { _ in }
  }
}
