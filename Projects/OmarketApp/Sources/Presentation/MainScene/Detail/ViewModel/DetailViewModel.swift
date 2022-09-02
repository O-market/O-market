//
//  DetailViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

protocol DetailViewModelInput {}

protocol DetailViewModelOutput {
  var productInfomation: Observable<DetailViewModelItem> { get }
  var productImageURL: Observable<[String]> { get }
  var productImageCount: Observable<Int> { get }
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModelImpl: DetailViewModel {
  let useCase: ProductFetchUseCase
  let productId: Int
  
  private let productBuffer = ReplaySubject<Product>.create(bufferSize: 1)
  private let bag = DisposeBag()
  
  init(useCase: ProductFetchUseCase, productId: Int) {
    self.useCase = useCase
    self.productId = productId
    
    self.useCase
      .fetchOne(id: productId)
      .subscribe(onNext: { [weak self] in
        self?.productBuffer.onNext($0)
      }, onError: { [weak self] in
        self?.productBuffer.onError($0)
      })
      .disposed(by: bag)
  }
  
  var productInfomation: Observable<DetailViewModelItem> {
    return productBuffer
      .map { DetailViewModelItem(product: $0) }
  }
  
  var productImageURL: Observable<[String]> {
    return productBuffer
      .compactMap { item in
        item.images?.compactMap { $0.url }
      }
  }
  
  var productImageCount: Observable<Int> {
    return productImageURL
      .map { $0.count }
  }
}
