//
//  MagpieError.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

enum MagpieError: Error {
  enum ImageDownloadErrorReason {
    case errorIsOccurred(_ error: String)
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case serviceUnavailable
    case invalidateResponse
    case unknown
  }

  case imageDownloadError(reason: ImageDownloadErrorReason)
}
