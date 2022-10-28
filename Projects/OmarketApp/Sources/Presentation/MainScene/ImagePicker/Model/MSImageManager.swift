//
//  MSImageManager.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/27.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Photos
import UIKit

final class MSImageManager {
  private let asset: PHAsset
  private let manager: PHCachingImageManager = .init()
  
  init(asset: PHAsset) {
    self.asset = asset
  }
  
  func request(
    size: CGSize,
    completion: @escaping (UIImage?) -> Void
  ) {
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    manager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: .aspectFill,
      options: options
    ) { image, _ in
      completion(image)
    }
  }
}
