//
//  DetailViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol DetailViewModelInput {
  func fetchProductDetail()
  func deleteButtonDidTap() -> Observable<Void>
  func selectEditAlertAction(_ actionTitle: String)
  func selectDeleteAlertAction(_ actionTitle: String)
}

protocol DetailViewModelOutput {
  var isMyProduct: Observable<Bool> { get }
  var productInfomation: Observable<DetailViewModelItem> { get }
  var productImageURL: Observable<[String]> { get }
  var productImageCount: Observable<Int> { get }
  var product: Product? { get }
  var editAction: Observable<Void> { get }
  var deleteAction: Observable<Void> { get }
}

protocol DetailViewModelable: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelable {
  private let useCase: ProductFetchUseCase
  private let productId: Int
  private(set) var product: Product?
  
  private let productBuffer = ReplaySubject<Product>.create(bufferSize: 1)
  private let editActionObserver = PublishRelay<Void>()
  private let deleteActionObserver = PublishRelay<Void>()
  private let deletionObserver = PublishRelay<Void>()
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
  }
  
  func deleteButtonDidTap() -> Observable<Void> {
    return deletionObserver
      .withUnretained(self)
      .flatMap { owner, _ in owner.useCase.productURL(id: owner.productId, password: UserInformation.password) }
      .withUnretained(self)
      .flatMap { owner, url in owner.useCase.deleteProduct(url: url) }
  }
  
  func fetchProductDetail() {
    useCase
      .fetchOne(id: productId)
      .subscribe(onNext: { [weak self] in
        self?.product = $0
        self?.productBuffer.onNext($0)
      }, onError: { [weak self] in
        self?.productBuffer.onError($0)
      })
      .disposed(by: disposeBag)
  }
  
  func selectEditAlertAction(_ actionTitle: String) {
    switch actionTitle {
    case "수정":
      editActionObserver.accept(())
    case "삭제":
      deleteActionObserver.accept(())
    default:
      break
    }
  }
  
  func selectDeleteAlertAction(_ actionTitle: String) {
    switch actionTitle {
    case "삭제":
      deletionObserver.accept(())
    default:
      break
    }
  }
  
  var isMyProduct: Observable<Bool> {
    return productBuffer
      .map {
        $0.vendor?.name == UserInformation.id
      }
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
  
  var editAction: Observable<Void> {
    return editActionObserver.asObservable()
  }
  
  var deleteAction: Observable<Void> {
    return deleteActionObserver.asObservable()
  }
}
