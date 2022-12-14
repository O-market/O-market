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
        XCTAssertEqual($0, "\(imageDatas.count)/\(self.sut.imageCountMax)")
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
  
  func test_selectedImageData를_호출했을때_이미_동일한_id의_data가_있으면_업데이트_되어야_한다() {
    // given
    let imageData = dummyImageData!
    let newImageData = ImageData(id: dummyImageData.id, data: Data())
    
    // when
    sut.selectedImageData(imageData)
    sut.selectedImageData(newImageData)
    sut.numberOfImagesSelected
      .subscribe {
        // then
        XCTAssertEqual($0, "1/\(self.sut.imageCountMax)")
      }.disposed(by: disposeBag)
    
    sut.requestCreation
      .subscribe { _ in
        // then
        XCTAssertEqual(self.productFetchuseCase.imageDatas, [newImageData.data])
      } onError: { _ in
        // then
        XCTFail()
      }.disposed(by: disposeBag)
    sut.doneButtonDidTap(errorMesaage: nil, product: dummyProduct)
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
        XCTAssertEqual($0, "0/\(self.sut.imageCountMax)")
      }.disposed(by: disposeBag)
  }
  
  func test_EmptyTextField가_없고_doneButtonDidTap를_호출했을_때_useCase에_product와_imageData가_전달되야_한다() {
    // given
    let imageDatas = [dummyImageData!]
    // when
    sut.selectedImageData(imageDatas.first!)
    sut.requestCreation
      .subscribe {
        // then
        XCTAssertEqual(self.productFetchuseCase.imageDatas, imageDatas.map { $0.data })
        XCTAssertTrue(self.productFetchuseCase.products.contains(self.dummyProduct))
      } onError: { _ in
        XCTFail()
      }.disposed(by: disposeBag)
    sut.doneButtonDidTap(errorMesaage: nil, product: dummyProduct)
  }
  
  func test_doneButton을_클릭했을_때_빈TextField가_있다면_errorMessage가_출력된다() {
    // given
    let emptyTextField = "제품 이름"
    // when
    sut.printErrorMessage
      .subscribe {
        // then
        XCTAssertEqual($0, emptyTextField + "은 필수 입력 항목입니다.")
      }.disposed(by: disposeBag)
    sut.doneButtonDidTap(errorMesaage: emptyTextField, product: nil)
  }
  
  func test_postErrorMessage를_호출해_Error를_보내면_errorMessage가_출력된다() {
    // given
    let error = NetworkServiceError.badRequest
    // when
    sut.printErrorMessage
      .subscribe {
        // then
        XCTAssertEqual($0, error.localizedDescription)
      }.disposed(by: disposeBag)
    sut.postErrorMessage(error)
  }
}


