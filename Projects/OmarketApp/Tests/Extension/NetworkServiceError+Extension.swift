//
//  NetworkServiceError+Extension.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation
@testable import OmarketApp

extension NetworkServiceError: Equatable {
  public static func == (lhs: NetworkServiceError, rhs: NetworkServiceError) -> Bool {
    return lhs.errorDescription == rhs.errorDescription
  }
}
