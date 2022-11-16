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
  var product: Product? { get }
}

protocol DetailViewModelable: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelable {
  private let useCase: ProductFetchUseCase
  private let productId: Int
  private(set) var product: Product?
  
  private let productBuffer = ReplaySubject<Product>.create(bufferSize: 1)
  private let disposeBag = DisposeBag()
  
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter
  }()
  
  init(useCase: ProductFetchUseCase, productId: Int) {
    self.useCase = useCase
    self.productId = productId
    
    self.useCase
      .fetchOne(id: productId)
      .subscribe(onNext: { [weak self] in
        self?.product = $0
        self?.productBuffer.onNext($0)
      }, onError: { [weak self] in
        self?.productBuffer.onError($0)
      })
      .disposed(by: disposeBag)
  }
  
  var productInfomation: Observable<DetailViewModelItem> {
    return productBuffer
      .map { [weak self] in
        DetailViewModelItem(product: $0, formatter: self?.numberFormatter)
      }
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
