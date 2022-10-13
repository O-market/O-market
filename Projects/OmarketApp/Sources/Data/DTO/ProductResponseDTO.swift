//
//  ProductResponseDTO.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductResponseDTO: Codable {
  let pageNumber: Int
  let itemsPerPage: Int
  let totalCount: Int
  let offset: Int
  let limit: Int
  let lastPage: Int
  let hasNext: Bool
  let hasPrev: Bool
  let products: [ProductDTO]

  private enum CodingKeys: String, CodingKey {
    case offset, limit, itemsPerPage, totalCount, lastPage, hasNext, hasPrev
    case pageNumber = "pageNo"
    case products = "pages"
  }
}

// MARK: - Extension

extension ProductResponseDTO {
  func toDomain() -> ProductResponse {
    return ProductResponse(
      pageNumber: pageNumber,
      itemsPerPage: itemsPerPage,
      hasNext: hasNext,
      products: products.map { $0.toDomain() }
    )
  }
}
