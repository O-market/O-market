//
//  ProductRepositoryTests.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

import RxSwift

final class ProductRepositoryTests: XCTestCase {
  private var networkService: StubNetworkServiceImpl!
  private var sut: ProductRepository!
  private var disposeBag: DisposeBag!
  private var dummyProductResponseDTO: ProductResponseDTO!

  override func setUpWithError() throws {
    try super.setUpWithError()

    dummyProductResponseDTO = ProductResponseDTO(
      pageNumber: 1,
      itemsPerPage: 10,
      totalCount: 10,
      offset: 0,
      limit: 9,
      lastPage: 0,
      hasNext: true,
      hasPrev: false,
      products: [
        ProductDTO(
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
      ]
    )

    let data = try! JSONEncoder().encode(dummyProductResponseDTO)
    networkService = StubNetworkServiceImpl(data: data, isSuccess: true)
    sut = ProductRepositoryImpl(networkService: networkService)
    disposeBag = DisposeBag()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    networkService = nil
    disposeBag = nil
  }

  func testFetchAllProduct을_호출했을때_성공한_경우_Product_배열이_나와야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.products(.init(pageNumber: 1, itemsPerPage: 10)).asEndpoint
    let input = dummyProductResponseDTO.products.map { $0.toDomain() }

    // when
    sut.fetchAllProduct(endpoint: endpoint)
      .subscribe(onNext: { products in
        // then
        XCTAssertEqual(products, input)
        expectation.fulfill()

      }, onError: { _ in
        XCTFail()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }

  func testFetchAllProduct을_호출했을때_실패한_경우_BadRequest가_나와야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.products(.init(pageNumber: 1, itemsPerPage: 10)).asEndpoint
    networkService = StubNetworkServiceImpl(data: Data(), isSuccess: false)
    sut = ProductRepositoryImpl(networkService: networkService)

    // when
    sut.fetchAllProduct(endpoint: endpoint)
      .subscribe(onNext: { _ in
        XCTFail()

      }, onError: { error in
        // then
        XCTAssertEqual(error as! NetworkServiceError, NetworkServiceError.badRequest)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }

  func testFetchProduct을_호출했을때_성공한_경우_Product가_나와야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.product(1).asEndpoint
    let product = dummyProductResponseDTO.products.first
    let data = try! JSONEncoder().encode(product)
    let input = dummyProductResponseDTO.products.map { $0.toDomain() }.first!

    networkService = StubNetworkServiceImpl(data: data, isSuccess: true)
    sut = ProductRepositoryImpl(networkService: networkService)

    // when
    sut.fetchProduct(endpoint: endpoint)
      .subscribe(onNext: { product in
        // then
        XCTAssertEqual(product, input)
        expectation.fulfill()

      }, onError: { _ in
        XCTFail()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }

  func testFetchProduct을_호출했을때_실패한_경우_BadRequest가_나와야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.product(1).asEndpoint
    networkService = StubNetworkServiceImpl(data: Data(), isSuccess: false)
    sut = ProductRepositoryImpl(networkService: networkService)

    // when
    sut.fetchProduct(endpoint: endpoint)
      .subscribe(onNext: { _ in
        XCTFail()

      }, onError: { error in
        // then
        XCTAssertEqual(error as! NetworkServiceError, NetworkServiceError.badRequest)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }
  
  func testCreateProduct을_호출했을때_성공한_경우_에러가_방출되지_않아야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.productCreation(Data(), UUID().uuidString).asEndpoint
    networkService = StubNetworkServiceImpl(data: Data(), isSuccess: true)
    sut = ProductRepositoryImpl(networkService: networkService)
    
    // when
    sut.createProduct(endpoint: endpoint)
      .subscribe(onNext: {
        // then
        expectation.fulfill()
      }, onError: { error in
        XCTFail()
      })
      .disposed(by: disposeBag)
    wait(for: [expectation], timeout: 5.0)
  }
  
  func testCreateProduct을_호출했을때_실패한_경우_BadRequest가_나와야한다() {
    // given
    let expectation = XCTestExpectation()
    let endpoint = EndpointAPI.productCreation(Data(), UUID().uuidString).asEndpoint
    networkService = StubNetworkServiceImpl(data: Data(), isSuccess: false)
    sut = ProductRepositoryImpl(networkService: networkService)
    
    // when
    sut.createProduct(endpoint: endpoint)
      .subscribe(onNext: {
        XCTFail()
      }, onError: { error in
        // then
        XCTAssertEqual(error as! NetworkServiceError, NetworkServiceError.badRequest)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    wait(for: [expectation], timeout: 5.0)
  }
}
