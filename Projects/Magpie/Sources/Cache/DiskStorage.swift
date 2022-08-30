//
//  DiskStorage.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class DiskStorage<T: UIImage>: Storage {
  let name: String

  init(name: String) {
    self.name = name
  }

  func setObject(_ object: T, forKey key: String) {
    guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return
    }

    let dirPath = path.appendingPathComponent("Image")
    let imageData = object.jpegData(compressionQuality: 0.5)

    if FileManager.default.fileExists(atPath: dirPath.path) == false {
      try? FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: false)
    }

    let component = URLComponents(string: key)
    if let newKey = component?.path.replacingOccurrences(of: "/", with: "_") {
      let filePath = dirPath.appendingPathComponent(newKey)
      try? imageData?.write(to: filePath)
    }
  }

  func object(forKey key: String) -> T? {
    guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }

    let dirPath = path.appendingPathComponent("Image")

    let component = URLComponents(string: key)
    if let newKey = component?.path.replacingOccurrences(of: "/", with: "_") {
      let filePath = dirPath.appendingPathComponent(newKey)
      let data = try? Data(contentsOf: filePath)
      return UIImage(data: data ?? Data()) as? T
    }
    return nil
  }
}
