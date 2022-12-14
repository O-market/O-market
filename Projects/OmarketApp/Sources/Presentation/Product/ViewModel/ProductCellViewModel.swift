//
//  ProductCellViewModel.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

protocol ProductCellViewModelInput { }

protocol ProductCellViewModelOutput {
  var imageURL: String { get }
  var productName: String { get }
  var price: String { get }
  var bargainPrice: String { get }
  var discountPercentage: String { get }
  var stockTitle: String { get }
  var stock: String { get }
  var isSoldout: Bool { get }
  var isSale: Bool { get }
}

protocol ProductCellViewModelable: ProductCellViewModelInput, ProductCellViewModelOutput { }

final class ProductCellViewModel: ProductCellViewModelable, CellViewModelable {
  // MARK: Properties

  private let product: Product
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter
  }()

  var imageURL: String {
    return product.thumbnail
  }

  var productName: String {
    return product.name
  }

  var price: String {
    return formattedString(product.price)
  }
  
  var bargainPrice: String {
    return formattedString(product.bargainPrice)
  }

  var discountPercentage: String {
    if product.price == 0 { return "0%" }
    
    let percentage = Int((product.discountedPrice / product.price * 100).rounded())
    return percentage == 0 ? "1%" : "\(percentage)%"
  }

  var stockTitle: String {
    return "잔여 수량"
  }

  var stock: String {
    return "\(product.stock) 개"
  }

  var isSoldout: Bool {
    return product.stock == .zero
  }

  var isSale: Bool {
    return product.discountedPrice != .zero
  }

  // MARK: Life Cycle

  init(product: Product) {
    self.product = product
  }

  // MARK: Methods

  // MARK: Helpers

  private func formattedString(_ number: Double) -> String {
    guard let number = numberFormatter.string(from: number as NSNumber) else { return "" }

    let currency = product.currency == "KRW" ? "원" : "달러"
    return number + "" + currency
  }
}
