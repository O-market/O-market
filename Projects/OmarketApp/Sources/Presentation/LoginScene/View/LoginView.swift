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
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = ODS.Image.logo
    return imageView
  }()
  
  private lazy var snsLoginStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [kakaoLoginButton,
                         googleLoginButton,
                         appleLoginButton,
                         emailLoginButton]
    )
    stackView.axis = .vertical
    stackView.spacing = 20
    return stackView
  }()
  
  private(set) var kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오로 로그인하기", for: .normal)
    button.backgroundColor = .yellow
    button.layer.cornerRadius = 6
    return button
  }()
  
  private(set) var googleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("구글로 로그인하기", for: .normal)
    button.backgroundColor = .blue
    button.layer.cornerRadius = 6
    return button
  }()
  
  private(set) var appleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("애플로 로그인하기", for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 6
    return button
  }()
  
  private(set) var emailLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("이메일로 로그인하기", for: .normal)
    button.backgroundColor = .purple
    button.layer.cornerRadius = 6
    return button
  }()

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
    self.addSubview(logoImageView)
    self.addSubview(snsLoginStackView)
  }
  
  private func setupLayout() {
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
      $0.width.height.equalTo(100)
      $0.centerX.equalTo(self.snp.centerX)
    }
    
    snsLoginStackView.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
    }

    kakaoLoginButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    googleLoginButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    appleLoginButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    emailLoginButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
  }
  
  private func setupView() {
    self.backgroundColor = .systemBackground
  }
}
