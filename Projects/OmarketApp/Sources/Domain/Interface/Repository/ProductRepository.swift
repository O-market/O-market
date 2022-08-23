//
//  ProductRepository.swift
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

protocol ProductRepository {
  func fetchAllProduct(query: ProductRequestQuery) -> Observable<[Product]>
  func fetchProduct(id: Int) -> Observable<Product>
}
