//
//  ProductRequestDTO.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductRequestDTO: Codable {
  let name: String
  let description: String
  var thumbnailId: Int?
  let price: Double
  let currency: String
  let discountedPrice: Double
  let stock: Int
  let vendorSecretKey: String

  private enum CodingKeys: String, CodingKey {
    case name, price, currency, stock
    case description = "descriptions"
    case thumbnailId = "thumbnail_id"
    case discountedPrice = "discounted_price"
    case vendorSecretKey = "secret"
  }
}
