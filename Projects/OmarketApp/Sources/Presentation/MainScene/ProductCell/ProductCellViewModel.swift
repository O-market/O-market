//
//  ProductCellViewModel.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

protocol ProductCellViewModelInput {
  // empty
}

protocol ProductCellViewModelOutput {
  var imageURL: String { get }
  var productName: String { get }
  var price: String { get }
  var discountedPrice: String { get }
  var dicountPercentage: String { get }
  var stockTitle: String { get }
  var stock: String { get }
  var isSale: Bool { get }
}

protocol ProductCellViewModelType: ProductCellViewModelInput, ProductCellViewModelOutput {}

final class ProductCellViewModel: ProductCellViewModelType {
  private let product: Product
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter
  }()
  
  // MARK: - OutPut
  
  var imageURL: String {
    return product.thumbnail
  }
  
  var productName: String {
    return product.name
  }
  
  var price: String {
    return formattedString(product.price)
  }
  
  var discountedPrice: String {
    return formattedString(product.discountedPrice)
  }
  
  var dicountPercentage: String {
    if product.price == 0 { return "0%" }
    
    let percentage = Int((product.bargainPrice / product.price * 100).rounded())
    return percentage == 0 ? "1%" : "\(percentage)%"
  }
  
  var stockTitle: String {
    return "잔여 수량"
  }
  
  var stock: String {
    return "\(product.stock) 개"
  }
  var isSale: Bool {
    return product.bargainPrice != .zero
  }
  
  init(product: Product) {
    self.product = product
  }
  
  private func formattedString(_ number: Double) -> String {
    guard let number = numberFormatter.string(from: number as NSNumber) else {
      return ""
    }
    
    let currency = product.currency == "KRW" ? "원" : "달러"
    
    return number + " " + currency
  }
}
