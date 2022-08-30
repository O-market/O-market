//
//  UIImageView+Magpie.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

private var imageTaskKey: Void?

extension Magpie where Base: UIImageView {
  private var imageTask: DownloadTask? {
    get { objc_getAssociatedObject(base, &imageTaskKey) as? DownloadTask }
    set { objc_setAssociatedObject(base, &imageTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  @discardableResult
  public func setImage(
    with urlString: String,
    placeholder: UIImage? = nil,
    completion: ((Result<UIImage, MagpieError>) -> Void)? = nil
  ) -> DownloadTask? {
    var mutatingSelf = self

    if let task = mutatingSelf.imageTask {
      mutatingSelf.imageTask = nil
      task.suspend()
      task.cancel()
    }

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
          DispatchQueue.main.async { [weak view = base as UIImageView] in
            view?.image = image
          }
          ImageCache.default.store(image, forKey: url.absoluteString)
          completion?(.success(image))
          return
        }
        completion?(.failure(.imageSettingError(reason: .invalidateImage)))

      case .failure(let error):
        completion?(.failure(error))
      }

      DispatchQueue.main.async { [weak view = base as UIImageView] in
        view?.image = placeholder
      }
    }
    mutatingSelf.imageTask = task
    return task
  }
}
