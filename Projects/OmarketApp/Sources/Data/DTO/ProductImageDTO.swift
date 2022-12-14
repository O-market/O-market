//
//  ProductImageDTO.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductImageDTO: Codable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let issuedAt: String

  private enum CodingKeys: String, CodingKey {
    case id, url
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

// MARK: - Extension

extension ProductImageDTO {
  func toDomain() -> ProductImage {
    return ProductImage(
      id: id,
      url: url,
      thumbnailURL: thumbnailURL,
      issuedAt: issuedAt
    )
  }
}
