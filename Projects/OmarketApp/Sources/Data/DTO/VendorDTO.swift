//
//  VendorDTO.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/16.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

struct VendorDTO: Codable {
  let id: Int
  let name: String

  private enum CodingKeys: String, CodingKey {
    case id, name
  }
}

// MARK: - Extension

extension VendorDTO {
  func toDomain() -> Vendor {
    return Vendor(
      id: id,
      name: name
    )
  }
}
