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
  
  private lazy var kakaoLoginManager = KakaoLoginManager(viewController: self)
  private lazy var googleLoginManager = GoogleLoginManager(viewController: self)
  private lazy var appleLoginManager = AppleLoginManager(viewController: self)
  
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
    
    view.kakaoLoginButton.rx.tap
      .bind { [weak self] in
        self?.kakaoLoginManager.startSignInWithKakaoFlow()
      }
      .disposed(by: disposeBag)
    
    view.googleLoginButton.rx.tap
      .bind { [weak self] in
        self?.googleLoginManager.startSignInWithGoogleFlow()
      }
      .disposed(by: disposeBag)
    
    view.appleLoginButton.rx.tap
      .bind { [weak self] in
        self?.appleLoginManager.startSignInWithAppleFlow()
      }
      .disposed(by: disposeBag)
    
    view.emailLoginButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.showEmailLogin()
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
      kakaoLoginManager.completed,
      googleLoginManager.completed,
      appleLoginManager.completed
    )
    .bind { [weak self] in
      self?.coordinator?.showMain()
    }
    .disposed(by: disposeBag)
    
    Observable.merge(
      kakaoLoginManager.error,
      googleLoginManager.error,
      appleLoginManager.error
    )
    .subscribe (onNext: { error in
      print("로그인 실패 \(error)")
    })
    .disposed(by: disposeBag)
  }
}
