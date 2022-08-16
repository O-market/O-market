//
//  ProductDTO.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductDTO: Codable {
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
  var images: [ProductImageDTO]?
  var vendor: VendorDTO?
  let createdAt: String
  let issuedAt: String

  private enum CodingKeys: String, CodingKey {
    case id, name, description, thumbnail, currency, price, stock, images
    case vendorId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case vendor = "vendors"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

// MARK: - Extension

extension ProductDTO {
  func toDomain() -> Product {
    return Product(
      id: id,
      vendorId: vendorId,
      name: name,
      description: description,
      thumbnail: thumbnail,
      currency: currency,
      price: price,
      bargainPrice: bargainPrice,
      discountedPrice: discountedPrice,
      stock: stock,
      images: images?.map { $0.toDomain() },
      vendor: vendor?.toDomain(),
      createdAt: createdAt,
      issuedAt: issuedAt
    )
  }
}
