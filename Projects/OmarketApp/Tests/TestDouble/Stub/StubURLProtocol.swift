//
//  StubURLProtocol.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
import XCTest

final class StubURLProtocol: URLProtocol {
  static var requestHandler: ((URLRequest) throws -> (Data, URLResponse))?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    guard let requestHandler = Self.requestHandler else { return XCTFail("Request Fail") }

    do {
      let (data, response) = try requestHandler(request)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocolDidFinishLoading(self)

    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }

  override func stopLoading() {}
}
