//
//  MagpieError.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

public enum MagpieError: Error {
  public enum ImageDownloadErrorReason {
    case errorIsOccurred(_ error: String)
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case serviceUnavailable
    case invalidateResponse
    case unknown
  }

  public enum ImageSettingErrorReason {
    case invalidateURL
    case invalidateImage
  }

  case imageDownloadError(reason: ImageDownloadErrorReason)
  case imageSettingError(reason: ImageSettingErrorReason)
}
