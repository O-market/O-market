//
//  EditingViewModelTest.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/11/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import XCTest
@testable import OmarketApp

import RxSwift

final class EditingViewModelTest: XCTestCase {
  private var sut: EditingViewModelable!
  private var productFetchUseCase: StubProductFetchUseCaseImpl!
  private var disposeBag: DisposeBag!
  private var dummyProduct: Product!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    let productImage = ProductImage(
      id: 1,
      url: "TestURL",
      thumbnailURL: "TestURL",
      issuedAt: "2022-01-24T00:00:00.00"
    )
    dummyProduct = Product(
      id: 1,
      vendorId: 1,
      name: "오픈마켓",
      description: "오픈마켓입니다",
      thumbnail: "",
      currency: "KRW",
      price: 1,
      bargainPrice: 1,
      discountedPrice: 1,
      stock: 1,
      images: [productImage],
      vendor: nil,
      createdAt: "2022/08/23",
      issuedAt: "2022/08/23"
    )
    
    productFetchUseCase = StubProductFetchUseCaseImpl(products: [dummyProduct])
    sut = EditingViewModel(useCase: productFetchUseCase, product: dummyProduct)
    disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    productFetchUseCase = nil
    disposeBag = nil
    dummyProduct = nil
  }
  
  func test_viewItem호출시_dummy와_동일한_EditingViewModelItem이_나와야한다() {
    // given
    let output = EditingViewModelItem(product: dummyProduct)
    
    // when
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item)
      }.disposed(by: disposeBag)
    
  }
  
  func test_inputTitle호출시_product의_title이_파라미터와_동일한_값으로_수정되어야_한다() {
    // given
    let output = "title Edit"
    // when
    sut.inputTitle(output)
    // then
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item.title)
      }.disposed(by: disposeBag)
  }
  
  func test_inputBody호출시_product의_body이_파라미터와_동일한_값으로_수정되어야_한다() {
    // given
    let output = "body Edit"
    // when
    sut.inputBody(output)
    // then
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item.body)
      }.disposed(by: disposeBag)
  }
  
  func test_inputPrice호출시_product의_price이_파라미터와_동일한_값으로_수정되어야_한다() {
    // given
    let output = "3.0"
    // when
    sut.inputPrice(output)
    // then
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item.price)
      }.disposed(by: disposeBag)
  }
  
  func test_inputDiscountPrice호출시_product의_discountPrice이_파라미터와_동일한_값으로_수정되어야_한다() {
    // given
    let output = "3.0"
    // when
    sut.inputDiscountPrice(output)
    // then
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item.discountPrice)
      }.disposed(by: disposeBag)
  }
  
  func test_inputStock호출시_product의_stock이_파라미터와_동일한_값으로_수정되어야_한다() {
    // given
    let output = "3"
    // when
    sut.inputStock(output)
    // then
    sut.viewItem
      .subscribe { item in
        // then
        XCTAssertEqual(output, item.stock)
      }.disposed(by: disposeBag)
  }
  
  func test_doneButtonDidTap를_통해_상품을_수정했을_때_useCase에_product가_전달되야_한다() {
    // given when
    sut.doneButtonAction
      .subscribe {
        // then
        XCTAssertTrue(self.productFetchUseCase.products.contains(self.dummyProduct))
      } onError: { _ in
        XCTFail()
      }.disposed(by: disposeBag)
    sut.doneButtonDidTap()
  }
}
