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
  func inputBody(_ body: String?)
  func inputPrice(_ price: String?)
  func inputDiscountPrice(_ price: String?)
  func inputStock(_ stock: String?)
  func doneButtonDidTap()
}

protocol EditingViewModelOutput {
  var viewItem: Observable<EditingViewModelItem> { get }
  var doneButtonAction: Observable<Void> { get }
}

protocol EditingViewModelable: EditingViewModelInput, EditingViewModelOutput {}

final class EditingViewModel: EditingViewModelable {
  private let useCase: ProductFetchUseCase
  private var product: Product
  private let doneButtonObservar = PublishRelay<Void>()
  
  init(useCase: ProductFetchUseCase, product: Product) {
    self.useCase = useCase
    self.product = product
  }
  
  func inputTitle(_ title: String?) {
    product.name = title ?? ""
  }
  
  func inputBody(_ body: String?) {
    product.description = body ?? ""
  }
  
  func inputPrice(_ price: String?) {
    product.price = Double(price ?? "") ?? 0.0
  }
  
  func inputDiscountPrice(_ price: String?) {
    product.discountedPrice = Double(price ?? "") ?? 0.0
  }
  
  func inputStock(_ stock: String?) {
    product.stock = Int(stock ?? "") ?? 0
  }
  
  func doneButtonDidTap() {
    doneButtonObservar.accept(())
  }
  
  var doneButtonAction: Observable<Void> {
    return doneButtonObservar
      .withUnretained(self)
      .flatMap { owner, _ in owner.useCase.updateProduct(product: owner.product) }
  }
  
  var viewItem: Observable<EditingViewModelItem> {
    return Observable.just(EditingViewModelItem(product: product))
  }
}
