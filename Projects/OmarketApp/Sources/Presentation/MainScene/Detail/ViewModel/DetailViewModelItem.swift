//
//  DetailViewModelItem.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct DetailViewModelItem {
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
