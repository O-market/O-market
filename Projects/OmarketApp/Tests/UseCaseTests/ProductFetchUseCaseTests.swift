//
//  ProductFetchUseCaseTests.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

import RxSwift

final class ProductFetchUseCaseTests: XCTestCase {
  private var sut: ProductFetchUseCase!
  private var repository: MockProductRepositoryImpl!
  private var dummyProduct: Product!

  override func setUpWithError() throws {
    try super.setUpWithError()
    repository = MockProductRepositoryImpl()
    sut = ProductFetchUseCaseImpl(repository: repository)
    dummyProduct = Product(
      id: 1,
      vendorId: 1,
      name: "오픈마켓",
      description: "오픈마켓입니다",
      thumbnail: "",
      currency: "KRW",
      price: 0,
      bargainPrice: 0,
      discountedPrice: 0,
      stock: 0,
      images: nil,
      vendor: nil,
      createdAt: "2022/08/23",
      issuedAt: "2022/08/23"
    )
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    repository = nil
    sut = nil
    dummyProduct = nil
  }

  func testFetchAll이_호출되었을때_Repository의_fetchAllProduct_메서드가_호출되어야한다() {
    // given
    let query = ProductRequestQuery(pageNumber: 1, itemsPerPage: 10)
    // when
    _ = sut.fetchAll(query: query)
    let output = repository.fetchAllProductCallCount

    // then
    XCTAssertEqual(output, 1)
  }

  func testFetchOne이_호출되었을때_Repository의_fetchProduct_메서드가_호출되어야한다() {
    // given when
    _ = sut.fetchOne(id: 1)
    let output = repository.fetchProductCallCount

    // then
    XCTAssertEqual(output, 1)
  }
  
  func testCreateProduct_호출되었을때_Repository의_createProduct_메서드가_호출되어야한다() {
    // given when
    _ = sut.createProduct(product: dummyProduct, images: [Data()])
    let output = repository.createProductCallCount
    
    // then
    XCTAssertEqual(output, 1)
  }
  
  func test_updateProduct가_호출되었을때_Repository의_updateProduct_메서드가_호출되어야한다() {
    // given when
    _ = sut.updateProduct(product: dummyProduct)
    let output = repository.updateProductCallCount
    
    // then
    XCTAssertEqual(output, 1)
  }
  
  func test_productURL호출되었을때_Repository의_productURL_메서드가_호출되어야한다() {
    // given when
    _ = sut.productURL(id: 1, password: "password")

    // then
    XCTAssertEqual(repository.productURLCallCount, 1)
  }
  
  func test_deleteProduct호출되었을때_Repository의_deleteProduct_메서드가_호출되어야한다() {
    // given when
    _ = sut.deleteProduct(url: "url")

    // then
    XCTAssertEqual(repository.deleteProductCallCount, 1)
  }
}
