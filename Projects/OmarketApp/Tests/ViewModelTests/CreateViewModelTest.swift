//
//  CreateViewModelTest.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/11/01.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

import RxSwift

final class CreateViewModelTest: XCTestCase {
  private var sut: CreationViewModelable!
  private var productFetchuseCase: StubProductFetchUseCaseImpl!
  private var disposeBag: DisposeBag!
  private var dummyImageData: ImageData!
  private var dummyProduct: Product!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    dummyImageData = ImageData(data: Data())
    
    dummyProduct = Product(
      id: 1,
      vendorId: 1,
      name: "오픈마켓",
      description: "오픈마켓입니다",
      thumbnail: "",
      currency: "KRW",
      price: 1,
      bargainPrice: 0,
      discountedPrice: 1,
      stock: 1,
      vendor: nil,
      createdAt: "2022/08/23",
      issuedAt: "2022/08/23"
    )
    
    productFetchuseCase = StubProductFetchUseCaseImpl(products: [dummyProduct])
    sut = CreationViewModel(useCase: productFetchuseCase, imageCountMax: 5, imageCountMin: 1)
    disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    productFetchuseCase = nil
    disposeBag = nil
    dummyProduct = nil
  }
  
  func test_selectedImageData를_통해_imageDatas를_추가했을_때_numberOfImagesSelected의_값이_imageDatas의_count와_같아야한다() {
    // given
    let imageDatas = [dummyImageData!]
    // when
    sut.selectedImageData(imageDatas.first!)
    sut.numberOfImagesSelected
      .subscribe {
        // then
        XCTAssertEqual($0, imageDatas.count)
      }.disposed(by: disposeBag)
  }
  
  func test_selectedImageData를_통해_imageDatas를_추가했을_때_selectionLimit는_imageCountLimit와_imageDatas의_count의_차여야한다() {
    // given
    let imageDatas = [dummyImageData!]
    // when
    sut.selectedImageData(imageDatas.first!)
    // then
    XCTAssertEqual(sut.selectionLimit, sut.imageCountMax - imageDatas.count)
  }
  
  func test_removeImageData를_통해_imageData를_삭제했을_때_numberOfImagesSelected의_값이_하나_감소해야한다() {
    // given
    let imageDatas = [dummyImageData!]
    // when
    sut.selectedImageData(imageDatas.first!)
    sut.removeImageData(id: dummyImageData.id)
    sut.numberOfImagesSelected
      .subscribe {
        // then
        XCTAssertEqual($0, imageDatas.count - 1)
      }.disposed(by: disposeBag)
  }
  
  func test_doneButtonDidTap를_통해_상품을_등록했을_때_useCase에_product와_imageData가_전달되야_한다() {
    // given
    let imageDatas = [dummyImageData!]
    // when
    sut.selectedImageData(imageDatas.first!)
    sut.doneButtonDidTap(product: dummyProduct)
      .subscribe {
        // then
        XCTAssertEqual(self.productFetchuseCase.imageDatas, imageDatas.map { $0.data })
        XCTAssertTrue(self.productFetchuseCase.products.contains(self.dummyProduct))
      } onError: { _ in
        XCTFail()
      }.disposed(by: disposeBag)
  }
}


