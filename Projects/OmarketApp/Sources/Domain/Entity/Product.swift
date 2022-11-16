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
  var name: String
  var description: String?
  let thumbnail: String
  let currency: String
  var price: Double
  let bargainPrice: Double
  var discountedPrice: Double
  var stock: Int
  var images: [ProductImage]?
  var vendor: Vendor?
  let createdAt: String
  let issuedAt: String
}
