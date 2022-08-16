//
//  Product.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct Product {
  let id: Int
  let vendorId: Int
  let name: String
  var description: String?
  let thumbnail: String
  let currency: String
  let price: Double
  let bargainPrice: Double
  let discountedPrice: Double
  let stock: Int
  var images: [ProductImage]?
  var vendor: Vendor?
  let createdAt: String
  let issuedAt: String
}
