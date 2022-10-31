//
//  ProductRequest.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductRequest: Encodable {
  var name: String?
  var description: String?
  var thumbnailId: Int?
  var price: Double?
  var currency: String?
  var discountedPrice: Double?
  var stock: Int?
  var vendorSecretKey: String?

  private enum CodingKeys: String, CodingKey {
    case name, price, currency, stock, description
    case thumbnailId = "thumbnail_id"
    case discountedPrice = "discounted_price"
    case vendorSecretKey = "secret"
  }
}
