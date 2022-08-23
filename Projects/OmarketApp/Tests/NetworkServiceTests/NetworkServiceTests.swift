//
//  NetworkServiceTests.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import XCTest
@testable import OmarketApp

import RxSwift

final class NetworkServiceTests: XCTestCase {
  private var sut: NetworkService!
  private var disposeBag: DisposeBag!

  override func setUpWithError() throws {
    try super.setUpWithError()
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [StubURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    sut = NetworkServiceImpl(urlSession: urlSession)
    disposeBag = DisposeBag()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    disposeBag = nil
  }

  func testRequest를_호출했을때_200이면_성공해야한다() {
    // given
    let expectation = XCTestExpectation()

    StubURLProtocol.requestHandler = { request in
      let data = Data()
      let response = HTTPURLResponse(
        url: URL(string: "https://market-training.yagom-academy.kr/")!,
        statusCode: 200,
        httpVersion: "1.1",
        headerFields: nil
      )!
      return (data, response)
    }

    // when
    let endpoint = EndpointAPI.products(.init(pageNumber: 1, itemsPerPage: 10)).asEndpoint

    sut.request(endpoint: endpoint)
      .subscribe(onNext: { _ in
        // then
        XCTAssertTrue(true)
        expectation.fulfill()
      }, onError: {
        XCTFail($0.localizedDescription)
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }

  func testRequest를_호출했을때_200이_아니면_실패해야한다() {
    // given
    let expectation = XCTestExpectation()

    StubURLProtocol.requestHandler = { request in
      let data = Data()
      let response = HTTPURLResponse(
        url: URL(string: "https://market-training.yagom-academy.kr/")!,
        statusCode: 400,
        httpVersion: "1.1",
        headerFields: nil
      )!
      return (data, response)
    }

    // when
    let endpoint = EndpointAPI.products(.init(pageNumber: 1, itemsPerPage: 10)).asEndpoint

    sut.request(endpoint: endpoint)
      .subscribe(onNext: { _ in
        XCTFail()
      }, onError: { error in
        // then
        XCTAssertTrue(true)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 5.0)
  }
}
