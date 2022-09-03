//
//  ViewAddable.swift
//  OmarketApp
//
//  Created by Ringo on 2022/09/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

protocol ViewAddable {}

// MARK: - Extension

extension ViewAddable where Self: UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}

extension ViewAddable where Self: UIStackView {
  func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { addArrangedSubview($0) }
  }
}

// MARK: - ViewAddable+UIView

extension UIView: ViewAddable {}
