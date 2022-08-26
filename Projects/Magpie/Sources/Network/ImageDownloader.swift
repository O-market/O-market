//
//  ImageDownloader.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

final class ImageDownloader {
  private var sessionConfiguration = URLSessionConfiguration.ephemeral
  private let session: URLSession

  init() {
    session = URLSession(
      configuration: sessionConfiguration,
      delegate: nil,
      delegateQueue: nil
    )
  }

  func download(
    urlRequest: URLRequest,
    completion: @escaping (Result<Data, MagpieError>) -> Void
  ) -> DownloadTask {
    let task = session.dataTask(with: urlRequest) { data, response, error in
      guard error == nil, let data = data else {
        completion(.failure(.imageDownloadError(reason: .errorIsOccurred(error.debugDescription))))
        return
      }
      guard let response = response as? HTTPURLResponse else {
        completion(.failure(.imageDownloadError(reason: .invalidateResponse)))
        return
      }

      switch response.statusCode {
      case 200..<300: completion(.success(data))
      case 400: completion(.failure(.imageDownloadError(reason: .badRequest)))
      case 401: completion(.failure(.imageDownloadError(reason: .unauthorized)))
      case 404: completion(.failure(.imageDownloadError(reason: .notFound)))
      case 500: completion(.failure(.imageDownloadError(reason: .internalServerError)))
      case 503: completion(.failure(.imageDownloadError(reason: .serviceUnavailable)))
      default: completion(.failure(.imageDownloadError(reason: .unknown)))
      }
    }
    task.resume()
    return task
  }
}
