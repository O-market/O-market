//
//  UIImageView+Extension.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

extension Magpie where Base: UIImageView {
  public func setImage(
    with urlString: String,
    completion: @escaping (Result<UIImage, MagpieError>) -> Void
  ) -> DownloadTask? {
    guard let url = URL(string: urlString) else {
      completion(.failure(.imageSettingError(reason: .invalidateURL)))
      return nil
    }

    let task = ImageDownloader.default.download(with: url) { result in
      switch result {
      case .success(let data):
        if let image = UIImage(data: data) {
          completion(.success(image))
        } else {
          completion(.failure(.imageSettingError(reason: .invalidateImage)))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
    return task
  }
}
