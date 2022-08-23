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

  override func setUpWithError() throws {
    try super.setUpWithError()
    repository = MockProductRepositoryImpl()
    sut = ProductFetchUseCaseImpl(repository: repository)
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    repository = nil
    sut = nil
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
}
