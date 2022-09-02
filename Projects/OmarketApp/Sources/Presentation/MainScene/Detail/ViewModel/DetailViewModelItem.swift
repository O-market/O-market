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
    
    if product.discountedPrice == 0 {
      self.price = nil
    } else {
      let formattedPrice = formatter?.string(from: product.price as NSNumber)
      self.price = (formattedPrice ?? "\(Int(product.price))") + " \(self.currency)"
    }
    
    self.bargainPrice = formatter?.string(from: product.bargainPrice as NSNumber) ?? "\(Int(product.bargainPrice))"
    
    let percentage = Int((product.discountedPrice / product.price * 100).rounded())
    if percentage == 0 {
      self.discountPercentage = nil
    } else if percentage < 1 {
      self.discountPercentage = "1%"
    } else {
      self.discountPercentage = "\(Int((product.discountedPrice / product.price * 100).rounded()))"
    }
    
    self.stock = "\(product.stock) 개"
  }
}
