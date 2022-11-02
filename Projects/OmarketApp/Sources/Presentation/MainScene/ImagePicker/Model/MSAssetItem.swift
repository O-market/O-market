//
//  MSAssetItem.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct MSAssetItem {
  let index: Int
  let assetIdentifier: String
  let imageManager: MSImageManager
  
  init(
    index: Int,
    assetIdentifier: String,
    assetManager: MSImageManager
  ) {
    self.index = index
    self.assetIdentifier = assetIdentifier
    self.imageManager = assetManager
  }
}
