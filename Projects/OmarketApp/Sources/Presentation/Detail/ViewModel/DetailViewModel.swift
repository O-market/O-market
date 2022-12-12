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
  func deleteButtonDidTap() -> Observable<Void>
  func selectEditAlertAction(_ actionTitle: String)
  func selectDeleteAlertAction(_ actionTitle: String)
}

protocol DetailViewModelOutput {
  var isMyProduct: Observable<Bool> { get }
  var requestProductDetail: Observable<DetailViewModelItem> { get }
  var productImageURL: Observable<[String]> { get }
  var productImageCount: Observable<Int> { get }
  var product: Product? { get }
  var editAction: Observable<Void> { get }
  var deleteAction: Observable<Void> { get }
  var printErrorMessage: Observable<String> { get }
}

protocol DetailViewModelable: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelable {
  private let useCase: ProductFetchUseCase
  private let productId: Int
  private(set) var product: Product?
  
  private let editActionObserver = PublishRelay<Void>()
  private let deleteActionObserver = PublishRelay<Void>()
  private let deletionObserver = PublishRelay<Void>()
  private let productObserver = PublishRelay<Product>()
  private let errorMessage = PublishRelay<String>()
  
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
      .catch {
        self.errorMessage.accept($0.localizedDescription)
        return .empty()
      }
      .withUnretained(self)
      .flatMap { owner, url in owner.useCase.deleteProduct(url: url) }
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
    return productObserver
      .map {
        $0.vendor?.name == UserInformation.id
      }
  }
  
  var productImageURL: Observable<[String]> {
    return productObserver
      .compactMap {
        $0.images?.compactMap { $0.url }
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
  
  var requestProductDetail: Observable<DetailViewModelItem> {
    return useCase
      .fetchOne(id: productId)
      .catch { error in
        self.errorMessage.accept(error.localizedDescription)
        return .empty()
      }.map { [weak self] in
        self?.product = $0
        self?.productObserver.accept($0)
        return DetailViewModelItem(
          product: $0,
          formatter: self?.numberFormatter
        )
      }
  }
  
  var printErrorMessage: Observable<String> {
    return errorMessage.asObservable()
  }
}
