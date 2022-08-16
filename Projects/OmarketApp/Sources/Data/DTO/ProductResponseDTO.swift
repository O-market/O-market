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
    case offset, limit
    case pageNumber = "page_no"
    case itemsPerPage = "items_per_page"
    case totalCount = "total_count"
    case lastPage = "last_page"
    case hasNext = "has_next"
    case hasPrev = "has_prev"
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
