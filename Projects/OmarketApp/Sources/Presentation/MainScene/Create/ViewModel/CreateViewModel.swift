//
//  CreateViewModel.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/24.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

protocol CreateViewModelInput {
  func selectedImageData(_ datas: [ImageData])
  func removeImageData(id: UUID)
}

protocol CreateViewModelOutput {
  var numberOfImagesSelected: Observable<Int> { get }
  var selectionLimit: Int { get }
}

protocol CreateViewModelable: CreateViewModelInput, CreateViewModelOutput {}

final class CreateViewModel: CreateViewModelable {
  private let useCase: ProductFetchUseCase
  private var imageDatas = BehaviorRelay<[ImageData]>(value: [])
  private var imageCountLimit: Int = 10
  
  init(useCase: ProductFetchUseCase) {
    self.useCase = useCase
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
