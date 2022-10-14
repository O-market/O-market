//
//  UIBarButtonItem+Extension.swift
//  OmarketApp
//
//  Created by Ringo on 2022/10/14.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  convenience init(title: String?) {
    self.init(title: title, style: .plain, target: nil, action: nil)
  }
}
