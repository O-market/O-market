//
//  EditingViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/07.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

protocol EditingViewModelInput {
  func inputTitle(_ title: String?)
  func inputBody(_ body: String)
  func inputPirce(_ price: String?)
  func inputDiscountPrice(_ price: String?)
  func intputStock(_ stock: String?)
  func doneButtonDidTap() -> Observable<Void>
}

protocol EditingViewModelOutput {
  var viewItem: Observable<EditingViewModelItem> { get }
}

protocol EditingViewModelable: EditingViewModelInput, EditingViewModelOutput {}

final class EditingViewModel: EditingViewModelable {
  private let useCase: ProductFetchUseCase
  private var product: Product
  
  init(useCase: ProductFetchUseCase, product: Product) {
    self.useCase = useCase
    self.product = product
  }
  
  func inputTitle(_ title: String?) {
    product.name = title ?? ""
  }
  
  func inputBody(_ body: String) {
    product.description = body
  }
  
  func inputPirce(_ price: String?) {
    product.price = Double(price ?? "") ?? 0.0
  }
  
  func inputDiscountPrice(_ price: String?) {
    product.discountedPrice = Double(price ?? "") ?? 0.0
  }
  
  func intputStock(_ stock: String?) {
    product.stock = Int(stock ?? "") ?? 0
  }
  
  func doneButtonDidTap() -> Observable<Void> {
    return useCase.updateProduct(product: product)
  }
  
  var viewItem: Observable<EditingViewModelItem> {
    return Observable.just(EditingViewModelItem(product: product))
  }
}

