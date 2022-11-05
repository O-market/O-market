//
//  ProductRepository.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

protocol ProductRepository {
  func fetchAllProduct(endpoint: Endpoint) -> Observable<[Product]>
  func fetchProduct(endpoint: Endpoint) -> Observable<Product>
  func createProduct(endpoint: Endpoint) -> Observable<Void>
  func updateProduct(endpoint: Endpoint) -> Observable<Void>
}
