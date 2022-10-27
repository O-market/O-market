//
//  AssetItem.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct AssetItem {
  let index: Int
  let assetIdentifier: String
  let imageManager: ImageManager
  
  init(
    index: Int,
    assetIdentifier: String,
    assetManager: ImageManager
  ) {
    self.index = index
    self.assetIdentifier = assetIdentifier
    self.imageManager = assetManager
  }
}
