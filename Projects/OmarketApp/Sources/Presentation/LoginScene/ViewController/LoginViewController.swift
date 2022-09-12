//
//  LoginViewController.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/11.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift

final class LoginViewController: UIViewController {

  private let viewModel: LoginViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: LoginCoordinator?
  
  init(_ viewModel: LoginViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    view = LoginView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if self.isMovingFromParent {
      coordinator?.deallocate()
    }
  }
  
  private func bind() {
    guard let view = view as? LoginView else { return }
    
    view.emailLoginButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.showEmailLogin()
      }
      .disposed(by: disposeBag)
  }
}
