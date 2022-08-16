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
  let createdAt: String
  let issuedAt: String

  private enum CodingKeys: String, CodingKey {
    case id, name
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
