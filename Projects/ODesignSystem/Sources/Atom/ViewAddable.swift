//
//  ViewAddable.swift
//  ODesignSystem
//
//  Created by Ringo on 2022/09/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

public protocol ViewAddable {}

// MARK: - Extension

extension ViewAddable where Self: UIView {
  public func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}

extension ViewAddable where Self: UIStackView {
  public func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { addArrangedSubview($0) }
  }
}

// MARK: - ViewAddable+UIView

extension UIView: ViewAddable {}
