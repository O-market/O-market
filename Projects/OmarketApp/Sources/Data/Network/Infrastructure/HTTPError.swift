//
//  HTTPError.swift
//  OmarketAppTests
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

enum HTTPError: LocalizedError {
  case createURLError

  var errorDescription: String? {
    switch self {
    case .createURLError:
      return "URL 생성에 실패했습니다."
    }
  }
}
