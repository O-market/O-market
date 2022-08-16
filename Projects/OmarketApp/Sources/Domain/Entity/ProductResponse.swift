//
//  ProductResponse.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ProductResponse {
  let pageNumber: Int
  let itemsPerPage: Int
  let hasNext: Bool
  let products: [Product]
}
