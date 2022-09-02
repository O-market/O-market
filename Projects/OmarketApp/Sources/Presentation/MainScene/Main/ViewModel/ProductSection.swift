//
//  ProductSection.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxDataSources

struct ProductSection {
  var items: [Product]
}

extension ProductSection: SectionModelType {
  typealias Item = Product

  init(original: ProductSection, items: [Product]) {
    self = original
    self.items = items
  }
}
