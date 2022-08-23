//
//  EndpointAPI.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

enum EndpointAPI {
  private enum Base {
    static let baseURL = "https://market-training.yagom-academy.kr/"
  }

  case products(ProductRequestQuery)
  case product(Int)

  var asEndpoint: Endpoint {
    switch self {
    case .products(let query):
      return Endpoint(
        base: Base.baseURL,
        path: "/api/products",
        method: .get,
        queries: [
          "page_no": query.pageNumber,
          "items_per_page": query.itemsPerPage
        ]
      )

    case .product(let id):
      return Endpoint(
        base: Base.baseURL,
        path: "/api/products/\(id)",
        method: .get
      )
    }
  }
}
