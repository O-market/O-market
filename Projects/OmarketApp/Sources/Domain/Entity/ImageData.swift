//
//  ImageData.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/28.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct ImageData {
  let id: UUID
  let data: Data
  
  init(id: UUID = UUID(), data: Data) {
    self.id = id
    self.data = data
  }
}
