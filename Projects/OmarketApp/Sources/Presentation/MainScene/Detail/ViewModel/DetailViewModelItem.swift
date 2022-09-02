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
  let currency: String
  let price: String?
  let bargainPrice: String
  let discountPercentage: String?
  let stock: String
  
  init(product: Product, formatter: NumberFormatter? = nil) {
    self.title = product.name
    self.body = product.description
    self.thumbnail = product.thumbnail
    self.currency = product.currency == "KRW" ? "원" : "달러"
    self.price = product.discountedPrice == 0 ? nil : (formatter?.string(from: product.price as NSNumber) ?? String(Int(product.price))) + " \(self.currency)"
    self.bargainPrice = formatter?.string(from: product.bargainPrice as NSNumber) ?? String(Int(product.bargainPrice))
    
    let percentage = Int((product.discountedPrice / product.price * 100).rounded()) < 1 ? 1 : Int((product.discountedPrice / product.price * 100).rounded())
    
    self.discountPercentage = product.discountedPrice == 0 ? nil :  String(percentage) + "%"
    self.stock = String(product.stock) + " 개"
  }
}
