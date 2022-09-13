//
//  RegisterViewController.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {
  
  private let viewModel: RegisterViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: RegisterCoordinator?
  
  init(_ viewModel: RegisterViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = RegisterView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.deallocate()
  }
  
  private func bind() {
    guard let view = view as? RegisterView else { return }
    let tapGesture = UITapGestureRecognizer()
    
    self.title = viewModel.title
    
    view.addGestureRecognizer(tapGesture)
    view.emailTextField.becomeFirstResponder()
    
    tapGesture.rx.event
      .bind { _ in
        view.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.text
      .orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.text
      .orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    view.checkedPasswordTextField.rx.text
      .orEmpty
      .bind(to: viewModel.checkedPassword)
      .disposed(by: disposeBag)    
    
    view.registerButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.didTapRegisterButton()
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.emailValidation,
          textField: view.emailTextField,
          borderColor: UIColor.purple.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidEnd])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.emailValidation,
          textField: view.emailTextField,
          borderColor: UIColor.systemGray5.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidEndOnExit])
      .bind {
        view.passwordTextField.becomeFirstResponder()
      }
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.passwordValidation,
          textField: view.passwordTextField,
          borderColor: UIColor.purple.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.controlEvent([.editingDidEnd])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.passwordValidation,
          textField: view.passwordTextField,
          borderColor: UIColor.systemGray5.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.controlEvent([.editingDidEndOnExit])
      .bind {
        view.checkedPasswordTextField.becomeFirstResponder()
      }
      .disposed(by: disposeBag)
    
    view.checkedPasswordTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.checkedPasswordValidation,
          textField: view.checkedPasswordTextField,
          borderColor: UIColor.purple.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    view.checkedPasswordTextField.rx.controlEvent([.editingDidEnd])
      .bind { [weak self] in
        guard let self = self else { return }
        
        self.changeTextFieldBorder(
          validation: self.viewModel.checkedPasswordValidation,
          textField: view.checkedPasswordTextField,
          borderColor: UIColor.systemGray5.cgColor
        )
      }
      .disposed(by: disposeBag)
    
    viewModel.registerButtonValidation
      .bind(to: view.registerButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    viewModel.registerButtonValidation
      .map { $0 ? 1 : 0.3 }
      .bind(to: view.registerButton.rx.alpha)
      .disposed(by: disposeBag)
    
    viewModel.successRegister
      .bind { [weak self] in
        self?.coordinator?.showMain()
      }
      .disposed(by: disposeBag)
    
    viewModel.error
      .bind {
        print("로그인 실패")
      }
      .disposed(by: disposeBag)
  }
}

extension RegisterViewController {
  private func changeTextFieldBorder(
    validation: Bool,
    textField: UITextField,
    borderColor: CGColor
  ) {
    if validation {
      textField.layer.borderColor = borderColor
    } else {
      textField.layer.borderColor = UIColor.red.cgColor
    }
  }
}
