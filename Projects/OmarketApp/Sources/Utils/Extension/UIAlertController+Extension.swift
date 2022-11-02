//
//  UIAlertController+Extension.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func makeAlert(message: String) -> UIAlertController {
    let alert = UIAlertController(
      title: nil,
      message: message,
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    return alert
  }
}
