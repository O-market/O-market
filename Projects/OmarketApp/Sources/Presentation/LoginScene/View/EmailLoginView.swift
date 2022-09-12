//
//  EmailLoginView.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class EmailLoginView: UIView {
  private lazy var emailStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [emailTitleLabel,
                         emailTextField]
    )
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private let emailTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "이메일"
    label.font = ODS.Font.B_B15
    return label
  }()
  
  private(set) var emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "이메일을 입력해주세요."
    textField.font = ODS.Font.B_R13
    textField.clearButtonMode = .whileEditing
    textField.borderStyle = .roundedRect
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    
    return textField
  }()
  
  private lazy var passwordStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [passwordTitleLabel,
                         passwordTextField,
                         passwordCheckLabel]
    )
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private let passwordTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호"
    label.font = ODS.Font.B_B15
    return label
  }()
  
  private(set) var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "비밀번호를 입력해주세요."
    textField.font = ODS.Font.B_R13
    textField.isSecureTextEntry = true
    textField.clearButtonMode = .whileEditing
    textField.borderStyle = .roundedRect
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    
    return textField
  }()
  
  private(set) var passwordCheckLabel: UILabel = {
    let label = UILabel()
    label.text = "소문자,대문자,숫자를 조합하여 10자리 이상 입력해주세요."
    label.font = ODS.Font.B_R11
    return label
  }()
  
  private lazy var loginStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [loginButton,
                         registerButton]
    )
    stackView.axis = .vertical
    return stackView
  }()
  
  private(set) var loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인", for: .normal)
    button.titleLabel?.font = ODS.Font.B_B15
    button.backgroundColor = .purple
    button.layer.cornerRadius = 6
    return button
  }()
  
  private(set) var registerButton: UIButton = {
    let button = UIButton()
    button.setTitle("처음이신가요? 회원가입", for: .normal)
    button.setTitleColor(UIColor.purple, for: .normal)
    button.titleLabel?.font = ODS.Font.B_R11
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
    self.addSubview(emailStackView)
    self.addSubview(passwordStackView)
    self.addSubview(loginStackView)
  }
  
  private func setupLayout() {
    emailStackView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
    }
    
    passwordStackView.snp.makeConstraints {
      $0.top.equalTo(emailStackView.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
    }
    
    loginStackView.snp.makeConstraints {
      $0.top.equalTo(passwordStackView.snp.bottom).offset(50)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
    }
    
    emailTextField.snp.makeConstraints {
      $0.height.equalTo(40)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.height.equalTo(40)
    }
    
    loginButton.snp.makeConstraints {
      $0.height.equalTo(40)
    }
  }
  
  private func setupView() {
    self.backgroundColor = .systemBackground
  }
}
