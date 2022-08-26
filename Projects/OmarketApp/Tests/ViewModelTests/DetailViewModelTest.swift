//
//  DetailViewModelTest.swift
//  OmarketAppTests
//
//  Created by 이시원 on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

import RxSwift

final class DetailViewModelTest: XCTestCase {
  private var sut: DetailViewModel!
  private var productFetchuseCase: StubProductFetchUseCaseImpl!
  private var disposeBag: DisposeBag!
  private var dummyProduct: Product!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
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
      images: nil,
      vendor: nil,
      createdAt: "2022/08/23",
      issuedAt: "2022/08/23"
    )
    
    productFetchuseCase = StubProductFetchUseCaseImpl(products: [dummyProduct])
    sut = DetailViewModelImpl(useCase: productFetchuseCase, productId: 1)
    disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    productFetchuseCase = nil
    disposeBag = nil
    dummyProduct = nil
  }
  
  func testProductInfomation를_호출했을_때_dummy와_동일한_DetailViewModelItem이_나와야한다() {
    // given
    let input = DetailViewModelItem(product: dummyProduct)
    
    // when
    sut.productInfomation
      .subscribe { product in
        
        // then
        XCTAssertEqual(product, input)
      }
      .disposed(by: disposeBag)
  }
}
