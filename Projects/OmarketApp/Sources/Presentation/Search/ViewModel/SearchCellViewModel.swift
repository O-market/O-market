//
//  SearchCellViewModel.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

protocol SearchCellViewModelInput {}
protocol SearchCellViewModelOutput {
  var product: Product { get }
}

protocol SearchCellViewModelable: SearchCellViewModelInput, SearchCellViewModelOutput {}

final class SearchCellViewModel: SearchCellViewModelable {
  let product: Product

  init(product: Product) {
    self.product = product
  }
}
