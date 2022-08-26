//
//  ImageCache.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class ImageCache {
  static let `default` = ImageCache(name: "default")

  private let memoryStorage: MemoryStorage<UIImage>
  private let diskStorage: DiskStorage<UIImage>

  init(
    memoryStorage: MemoryStorage<UIImage>,
    diskStorage: DiskStorage<UIImage>
  ) {
    self.memoryStorage = memoryStorage
    self.diskStorage = diskStorage
  }

  convenience init(name: String) {
    let memoryStorage = MemoryStorage<UIImage>()
    let diskStorage = DiskStorage<UIImage>(name: name)
    self.init(memoryStorage: memoryStorage, diskStorage: diskStorage)
  }

  func store(_ image: UIImage, forKey key: String) {
    memoryStorage.setObject(image, forKey: key)
    diskStorage.setObject(image, forKey: key)
  }

  func retrieve(forKey key: String) -> UIImage? {
    if let memoryImage = memoryStorage.value(forKey: key) {
      return memoryImage
    }

    if let diskImage = diskStorage.value(forKey: key) {
      memoryStorage.setObject(diskImage, forKey: key)
      return diskImage
    }
    return nil
  }
}
