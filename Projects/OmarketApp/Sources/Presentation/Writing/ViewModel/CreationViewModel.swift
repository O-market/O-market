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
  func doneButtonDidTap(product: Product) -> Observable<Void>
  func removeImageData(id: UUID)
  func selectedImageData(_ datas: [ImageData])
}

protocol CreationViewModelOutput {
  var numberOfImagesSelected: Observable<Int> { get }
  var selectionLimit: Int { get }
  var imageCountLimit: Int { get }
}

protocol CreationViewModelable: CreationViewModelInput, CreationViewModelOutput {}

final class CreationViewModel: CreationViewModelable {
  private let useCase: ProductFetchUseCase
  private var imageDatas = BehaviorRelay<[ImageData]>(value: [])
  let imageCountLimit: Int = 5
  
  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase
  }
  
  func doneButtonDidTap(product: Product) -> Observable<Void> {
    return useCase.createProduct(
      product: product,
      images: imageDatas.value.map { $0.data })
  }
  
  func selectedImageData(_ datas: [ImageData]) {
    let value = imageDatas.value
    imageDatas.accept(value + datas)
  }
  
  func removeImageData(id: UUID) {
    guard let dataIndex = imageDatas.value.firstIndex(where: { $0.id == id }) else { return }
    var value = imageDatas.value
    value.remove(at: dataIndex)
    imageDatas.accept(value)
  }
  
  var numberOfImagesSelected: Observable<Int> {
    imageDatas
      .map { $0.count }
  }
  
  var selectionLimit: Int {
    imageCountLimit - imageDatas.value.count
  }
}