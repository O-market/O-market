//
//  UIImageView+Extension.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

extension Magpie where Base: UIImageView {
  @discardableResult
  public func setImage(
    with urlString: String,
    placeholder: UIImage? = nil,
    completion: ((Result<UIImage, MagpieError>) -> Void)? = nil
  ) -> DownloadTask? {
    guard let url = URL(string: urlString) else {
      completion?(.failure(.imageSettingError(reason: .invalidateURL)))
      return nil
    }

    if let image = ImageCache.default.retrieve(forKey: url.absoluteString) {
      self.base.image = image
      return nil
    }

    let task = ImageDownloader.default.download(with: url) { result in
      switch result {
      case .success(let data):
        if let image = UIImage(data: data) {
          self.base.image = image
          ImageCache.default.store(image, forKey: url.absoluteString)
          completion?(.success(image))
          return
        }
        completion?(.failure(.imageSettingError(reason: .invalidateImage)))

      case .failure(let error):
        completion?(.failure(error))
      }
      self.base.image = placeholder
    }
    return task
  }
}
