//
//  MainViewModel.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

protocol MainViewModelInput {
  func showProductAllScene()
}

protocol MainViewModelOutput {
  var sections: BehaviorRelay<[ProductSection]> { get }
}

protocol MainViewModelable: MainViewModelInput & MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
  var sections = BehaviorRelay<[ProductSection]>(value: [
    ProductSection(items: [
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: "")
    ]),
    ProductSection(items: [
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: ""),
      Product(id: 1, vendorId: 1, name: "", thumbnail: "", currency: "", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: "")
    ])
  ])

  init() {}

  func showProductAllScene() {}
}
