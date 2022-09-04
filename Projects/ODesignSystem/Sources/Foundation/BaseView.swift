//
//  BaseView.swift
//  ODesignSystem
//
//  Created by Ringo on 2022/09/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func layout() {}
}
