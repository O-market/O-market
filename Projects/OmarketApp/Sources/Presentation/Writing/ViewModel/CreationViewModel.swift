//
//  CreationViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

protocol CreationViewModelInput {
  func removeImageData(id: UUID)
  func selectedImageData(_ imageData: ImageData)
  func doneButtonDidTap(errorMesaage: String?, product: Product?)
  func postErrorMessage(_ error: Error)
}

protocol CreationViewModelOutput {
  var numberOfImagesSelected: Observable<String> { get }
  var selectionLimit: Int { get }
  var imageCountMax: Int { get }
  var imageCountMin: Int { get }
  var printErrorMessage: Observable<String> { get }
  var requestCreation: Observable<Void> { get }
}

protocol CreationViewModelable: CreationViewModelInput, CreationViewModelOutput {}

final class CreationViewModel: CreationViewModelable {
  // MARK: Properties
  
  private let useCase: ProductFetchUseCase
  private let imageDatas = BehaviorRelay<[ImageData]>(value: [])
  private let errorMessage = PublishRelay<String>()
  private let creationObservar = PublishRelay<Product>()
  let imageCountMax: Int
  let imageCountMin: Int
  
  // MARK: Life Cycle
  
  init(
    useCase: ProductFetchUseCase,
    imageCountMax: Int,
    imageCountMin: Int
  ) {
    self.useCase = useCase
    self.imageCountMax = imageCountMax
    self.imageCountMin = imageCountMin
  }
  
  // MARK: Methods
  
  var requestCreation: Observable<Void> {
    return creationObservar
      .withUnretained(self)
      .flatMap { owner, product in
        owner.useCase.createProduct(
          product: product,
          images: owner.imageDatas.value.map { $0.data }
        )
      }
  }
  
  func selectedImageData(_ imageData: ImageData) {
    if let dataIndex = imageDatas.value.firstIndex(where: { $0.id == imageData.id }) {
      var value = imageDatas.value
      value[dataIndex] = imageData
      imageDatas.accept(value)
    } else {
      let value = imageDatas.value
      imageDatas.accept(value + [imageData])
    }
  }
  
  func removeImageData(id: UUID) {
    guard let dataIndex = imageDatas.value.firstIndex(where: { $0.id == id }) else { return }
    var value = imageDatas.value
    value.remove(at: dataIndex)
    imageDatas.accept(value)
  }
  
  func doneButtonDidTap(errorMesaage: String?, product: Product?) {
    if let textFields = errorMesaage {
      errorMessage.accept(textFields + "은 필수 입력 항목입니다.")
    } else if let product = product {
      creationObservar.accept(product)
    }
  }
  
  func postErrorMessage(_ error: Error) {
    errorMessage.accept(error.localizedDescription)
  }
  
  var numberOfImagesSelected: Observable<String> {
    imageDatas
      .withUnretained(self)
      .map { owner, imageDatas in
        "\(imageDatas.count)/\(owner.imageCountMax)"
      }
  }
  
  var selectionLimit: Int {
    imageCountMax - imageDatas.value.count
  }
  
  var printErrorMessage: Observable<String> {
    return errorMessage.asObservable()
  }
  
  // MARK: Helpers
}
