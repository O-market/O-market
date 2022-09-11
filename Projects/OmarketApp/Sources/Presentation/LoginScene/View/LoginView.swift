//
//  LoginView.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/11.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class LoginView: UIView {

  init() {
    super.init(frame: .zero)
    addViews()
    setupLayout()
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addViews() {

  }
  
  private func setupLayout() {

  }
  
  private func setupView() {
    self.backgroundColor = .systemBackground
  }
}
