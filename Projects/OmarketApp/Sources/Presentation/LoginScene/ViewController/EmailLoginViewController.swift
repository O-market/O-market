//
//  EmailLoginViewController.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift

final class EmailLoginViewController: UIViewController {

  private let viewModel: EmailLoginViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: EmailLoginCoordinator?
  
  init(_ viewModel: EmailLoginViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = EmailLoginView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    bind()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if self.isMovingFromParent {
      coordinator?.deallocate()
    }
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func bind() {
    guard let view = view as? EmailLoginView else { return }
    let tapGesture = UITapGestureRecognizer()
    
    self.title = viewModel.title
    
    view.addGestureRecognizer(tapGesture)
    
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
    
    view.registerButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.showRegister()
      }
      .disposed(by: disposeBag)
    
    view.loginButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.didTapLoginButton()
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidBegin])
      .bind {
        view.emailTextField.layer.borderColor = UIColor.purple.cgColor
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidEnd])
      .bind {
        view.emailTextField.layer.borderColor = UIColor.systemGray5.cgColor
      }
      .disposed(by: disposeBag)
    
    view.emailTextField.rx.controlEvent([.editingDidEndOnExit])
      .bind {
        view.passwordTextField.becomeFirstResponder()
      }
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.controlEvent([.editingDidBegin])
      .bind {
        view.passwordTextField.layer.borderColor = UIColor.purple.cgColor
      }
      .disposed(by: disposeBag)
    
    view.passwordTextField.rx.controlEvent([.editingDidEnd])
      .bind {
        view.passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
      }
      .disposed(by: disposeBag)
    
    viewModel.loginButtonValidation
      .bind(to: view.loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    viewModel.loginButtonValidation
      .map { $0 ? 1 : 0.3 }
      .bind(to: view.loginButton.rx.alpha)
      .disposed(by: disposeBag)
    
    viewModel.successLogin
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
