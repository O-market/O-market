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
  var discountPercentage: String?
  let stock: String
  
  init(product: Product, formatter: NumberFormatter? = nil) {
    self.title = product.name
    self.body = product.description
    self.thumbnail = product.thumbnail
    self.currency = product.currency == "KRW" ? "원" : "달러"
    self.stock = "\(product.stock) 개"
    self.bargainPrice = formatter?.string(
      from: product.bargainPrice as NSNumber
    ) ?? "\(Int(product.bargainPrice))"
    
    if product.bargainPrice == 0 {
      self.price = nil
    } else {
      let formattedPrice = formatter?.string(from: product.price as NSNumber)
      self.price = (formattedPrice ?? "\(Int(product.price))") + " \(self.currency)"
    }
    
    if product.price != 0 {
      self.discountPercentage = self.calculateDiscountPercent(product: product)
    }
  }
  
  private func calculateDiscountPercent(product: Product) -> String {
    let percentage = Int((product.discountedPrice / product.price * 100).rounded())
    
    if percentage == 0 { return "0%" }
    if percentage < 1 { return "1%" }
    return "\(percentage)%"
  }
}
