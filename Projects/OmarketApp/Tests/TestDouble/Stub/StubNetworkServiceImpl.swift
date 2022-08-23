//
//  StubNetworkServiceImpl.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

import RxSwift

final class StubNetworkServiceImpl: NetworkService {
  private let data: Data
  private let isSuccess: Bool

  init(data: Data, isSuccess: Bool) {
    self.data = data
    self.isSuccess = isSuccess
  }

  func request(endpoint: Endpoint) -> Observable<Data> {
    if isSuccess {
      return .just(data)
    } else {
      return .error(NetworkServiceError.badRequest)
    }
  }
}
