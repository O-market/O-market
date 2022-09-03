//
//  ProductSection.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxDataSources

enum ProductSectionType {
  case event
  case product
}

struct ProductSection {
  var sectionType: ProductSectionType
  var items: [CellItem]
}

extension ProductSection: SectionModelType {
  typealias Item = CellItem

  init(original: ProductSection, items: [CellItem]) {
    self = original
    self.items = items
  }
}

protocol CellItem {}

extension Product: CellItem {}

struct ProductEvent: CellItem {
  var name: String
}
