//
//  EditingViewModelItem.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/07.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct EditingViewModelItem {
  let title: String
  let body: String
  let price: String
  let discountPrice: String
  let stock: String
  
  init(product: Product) {
    self.title = product.name
    self.body = product.description ?? ""
    self.price = "\(product.price)"
    self.discountPrice = "\(product.discountedPrice)"
    self.stock = "\(product.stock)"
  }
}
