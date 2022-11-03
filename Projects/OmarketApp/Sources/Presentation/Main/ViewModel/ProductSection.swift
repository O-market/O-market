//
//  ProductSection.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxDataSources

protocol ProductSectionItemType { }

enum ProductSectionType {
  case event
  case product
}

struct ProductSection {
  var sectionType: ProductSectionType
  var items: [ProductSectionItemType]
}

extension ProductSection: SectionModelType {
  typealias Item = ProductSectionItemType

  init(original: ProductSection, items: [ProductSectionItemType]) {
    self = original
    self.items = items
  }
}

struct ProductEvent: ProductSectionItemType {
  var name: String
}

// MARK: - Extension

extension Product: ProductSectionItemType { }

extension ProductEvent {
  static let items = ["event01", "event02", "event03", "event04"].map { ProductEvent(name: $0) }
}
