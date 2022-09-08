//
//  FormDataBuilder.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/09/08.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

enum MIMEType: String {
  case json = "application/json"
  case png = "image/png"
  case jpeg = "image/jpeg"
}

struct FormData {
  var type: MIMEType
  var name: String
  var filename: String? = nil
  var data: Data?
}

final class FormDataBuilder {
  private var data = Data()
  private let boundary: String
  private var boundaryPrefix: String { "\r\n--\(boundary)\r\n" }
  private var boundarySuffix: String { "\r\n--\(boundary)--\r\n" }
  
  private init(boundary: String) {
    self.boundary = boundary
  }
  
  static func create(token: String) -> FormDataBuilder {
    return FormDataBuilder(boundary: token)
  }
  
  @discardableResult
  func append(_ form: FormData) -> FormDataBuilder {
    guard let formData = form.data else { return self }
    
    self.data.appendString(boundaryPrefix)
    self.data.appendString("Content-Disposition: form-data; name=\"\(form.name)\"")
    if let filename = form.filename {
      data.appendString("; filename=\"\(filename)\"")
    }
    self.data.appendString("\r\n")
    self.data.appendString("Content-Type: \(form.type.rawValue)\r\n\r\n")
    self.data.append(formData)
    return self
  }
  
  func append(_ forms: [FormData]) -> FormDataBuilder {
    forms.forEach { append($0) }
    return self
  }
  
  func apply() -> Data {
    self.data.appendString(boundarySuffix)
    return self.data
  }
}

private extension Data {
  mutating func appendString(_ stringValue: String) {
    if let data = stringValue.data(using: .utf8) {
      self.append(data)
    }
  }
}
