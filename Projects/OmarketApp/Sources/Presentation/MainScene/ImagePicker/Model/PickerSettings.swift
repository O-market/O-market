//
//  PickerSettings.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/27.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class PickerSettings {
  var selectionLimit: Int?
  var selectedIndicatorColor: UIColor
  
  init(
    selectionLimit: Int? = nil,
    selectedIndicatorColor: UIColor = .systemIndigo
  ) {
    self.selectionLimit = selectionLimit
    self.selectedIndicatorColor = selectedIndicatorColor
  }
}
