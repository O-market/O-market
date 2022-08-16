//
//  DTOTests.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

final class DTOTests: XCTestCase {
  private var decoder: JSONDecoder!

  override func setUpWithError() throws {
    try super.setUpWithError()
    decoder = JSONDecoder()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    decoder = nil
  }

  func testProductDTO_데이터가_주어졌을떄_제대로_디코딩_되어야한다() {
    // given
    let data = makeData(fileName: "ProductJSON", ofType: "json")!

    // when
    let productDTO = try? decoder.decode(ProductDTO.self, from: data)

    // then
    XCTAssertNotNil(productDTO)
  }

  func testProductResponseDTO_데이터가_주어졌을때_제대로_디코딩_되어야한다() {
    // given
    let data = makeData(fileName: "ProductResponseJSON", ofType: "json")!

    // when
    let productResponseDTO = try? decoder.decode(ProductResponseDTO.self, from: data)

    // then
    XCTAssertNotNil(productResponseDTO)
  }

  func testProductImageDTO_데이터가_주어졌을때_제대로_디코딩_되어야한다() {
    // given
    let data = makeData(fileName: "ProductImageJSON", ofType: "json")!

    // when
    let productImageDTO = try? decoder.decode(ProductImageDTO.self, from: data)

    // then
    XCTAssertNotNil(productImageDTO)
  }

  func testVendorDTO_데이터가_주어졌을때_제대로_디코딩_되어야한다() {
    // given
    let data = makeData(fileName: "VendorJSON", ofType: "json")!

    // when
    let vendorDTO = try? decoder.decode(VendorDTO.self, from: data)

    // then
    XCTAssertNotNil(vendorDTO)
  }

  func testProductRequestDTO_데이터가_주어졌을때_제대로_인코딩_되어야한다() {
    // given
    let encoder = JSONEncoder()
    let productRequestDTO = ProductRequestDTO(
      name: "Test Product",
      description: "description here",
      price: 15000,
      currency: "KRW",
      discountedPrice: 0,
      stock: 1000,
      vendorSecretKey: "your_secret_here"
    )

    // when
    let encodedData = try? encoder.encode(productRequestDTO)

    // then
    XCTAssertNotNil(encodedData)
  }
}

// MARK: - Extension

extension DTOTests {
  func makeData(fileName: String, ofType: String) -> Data? {
    let bundle = Bundle(for: DTOTests.self)
    let path = bundle.path(forResource: fileName, ofType: ofType)
    return try? Data(contentsOf: URL(fileURLWithPath: path!))
  }
}
