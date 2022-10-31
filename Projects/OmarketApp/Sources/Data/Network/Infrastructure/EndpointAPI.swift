//
//  EndpointAPI.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

#if DEBUG
enum UserInformation {
    static let id = "safari123"
    static let identifier = "f29c702b-58ef-11ed-a917-232fe9321977"
    static let password = "8svnb243vbbnnjap"
}
#endif

enum EndpointAPI {
  private enum Base {
    static let baseURL = "https://openmarket.yagom-academy.kr"
  }

  case products(ProductRequestQuery)
  case product(Int)
  case productCreation(Data, String)

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
      
    case .productCreation(let payload, let boundary):
      return Endpoint(
        base: Base.baseURL,
        path: "/api/products",
        method: .post,
        headers: [
          "Content-Type": "multipart/form-data; boundary=\(boundary)",
          "identifier": UserInformation.identifier
        ],
        payload: payload)
    }
  }
}
